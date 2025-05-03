import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';
import '../view/compareSalariesCities_view.dart';
import '../presenter/global_presenter.dart';

class SWESearchView extends StatefulWidget {
  const SWESearchView({super.key});

  @override
  _SWESearchViewState createState() => _SWESearchViewState();
}

class _SWESearchViewState extends State<SWESearchView> implements JobView {
  late JobPresenter _presenter;
  List<JobEntry> _allJobs = [];
  List<JobEntry> _filteredJobs = [];
  Set<String> _favoriteJobIds = {};
  final _scrollController = ScrollController();
  final int _itemsPerPage = 20;
  int _currentLoaded = 20;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalEmail)
      .collection('favorites');

  @override
  void initState() {
    super.initState();
    _presenter = JobPresenter(this);
    _presenter.loadJobsFromCSV('assets/datasets/SWE-JAS.csv');

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreJobs();
      }
    });
  }

  @override
  void onJobsLoaded(List<JobEntry> jobs) async {
    _allJobs = jobs;
    _filteredJobs = jobs;
    await _loadFavorites();
    setState(() {
      _isLoading = false;
      _currentLoaded = _itemsPerPage.clamp(0, _filteredJobs.length);
    });
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  Future<void> _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    final ids = snapshot.docs.map((doc) => doc.id).toSet();

    setState(() {
      _favoriteJobIds = ids;

      for (var job in _filteredJobs) {
        final jobId = job.jobTitle + job.company + job.location;
        job.isFavorite = _favoriteJobIds.contains(jobId);
      }

      for (var job in _allJobs) {
        final jobId = job.jobTitle + job.company + job.location;
        job.isFavorite = _favoriteJobIds.contains(jobId);
      }
    });
  }

  void _filterJobs(String query) {
    final lower = query.toLowerCase();
    final results =
        _allJobs
            .where((job) => job.jobTitle.toLowerCase().contains(lower))
            .toList();
    setState(() {
      _searchQuery = query;
      _filteredJobs = results;
      _currentLoaded = _itemsPerPage.clamp(0, results.length);
    });
  }

  void _loadMoreJobs() {
    if (_currentLoaded < _filteredJobs.length) {
      setState(() {
        _currentLoaded = (_currentLoaded + _itemsPerPage).clamp(
          0,
          _filteredJobs.length,
        );
      });
    }
  }

  void _toggleFavorite(JobEntry job) async {
    final jobId = job.jobTitle + job.company + job.location;

    if (_favoriteJobIds.contains(jobId)) {
      await favoritesRef.doc(jobId).delete();
      setState(() {
        _favoriteJobIds.remove(jobId);
        job.isFavorite = false;
      });
    } else {
      await favoritesRef.doc(jobId).set({
        'Title': job.jobTitle,
        'Company': job.company,
        'Company Score': job.companyScore,
        'Location': job.location,
        'Date': job.date,
        'Salary': job.salary,
      });
      setState(() {
        _favoriteJobIds.add(jobId);
        job.isFavorite = true;
      });
    }
  }

  Widget _buildFavoriteIcon(JobEntry job) {
    return job.isFavorite
        ? Stack(
          alignment: Alignment.center,
          children: const [
            Icon(
              Icons.star_border,
              color: Color.fromARGB(255, 151, 135, 8),
              size: 32,
            ),
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 242, 201, 76),
              size: 24,
            ),
          ],
        )
        : const Icon(Icons.star_border, color: Colors.grey, size: 32);
  }

  TextStyle _descriptionStyle() => const TextStyle(
    color: Color.fromARGB(255, 34, 124, 157),
    fontFamily: 'JetB',
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 17, 84, 116),
                        fontFamily: 'JetB',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Search by job title',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(150, 17, 84, 116),
                          fontFamily: 'JetB',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 84, 116),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              34,
                              124,
                              157,
                            ), // Border when focused
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onChanged: _filterJobs,
                    ),
                  ),

                  // Button goes to compareSalariesCities_view.dart
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CompareCitiesScreen(jobs: _filteredJobs),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 43, 75),
                      foregroundColor: Color.fromARGB(255, 244, 243, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Compare Salaries by City',
                      style: TextStyle(
                        fontFamily: 'inter',
                        color: Color.fromARGB(255, 244, 243, 240),
                        fontSize: 12,
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        _filteredJobs.isEmpty
                            ? const Center(child: Text('No jobs found.'))
                            : ListView.builder(
                              controller: _scrollController,
                              itemCount: _currentLoaded,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                return Card(
                                  color: const Color.fromARGB(
                                    255,
                                    230,
                                    230,
                                    226,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: ExpansionTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide.none,
                                    ),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide.none,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      230,
                                      230,
                                      226,
                                    ),
                                    title: Text(
                                      job.jobTitle,
                                      style: const TextStyle(
                                        fontFamily: 'inter',
                                        color: Color.fromARGB(255, 0, 43, 75),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${job.company} • ${job.location}',
                                      style: const TextStyle(
                                        fontFamily: 'JetB',
                                        color: Color.fromARGB(255, 17, 84, 116),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: _buildFavoriteIcon(job),
                                      onPressed: () => _toggleFavorite(job),
                                    ),
                                    children: [
                                      const Divider(
                                        color: Color.fromARGB(255, 0, 43, 75),
                                        thickness: 2,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Company Score: ${job.companyScore}',
                                          style: _descriptionStyle(),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              'Date Posted: ${job.date}',
                                              style: _descriptionStyle(),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Salary: ${job.salary}',
                                              style: _descriptionStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
