import 'package:flutter/material.dart';
import '../globals/user_info.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SWESearchView extends StatefulWidget {
  const SWESearchView({super.key});

  @override
  _SWESearchViewState createState() => _SWESearchViewState();
}

class _SWESearchViewState extends State<SWESearchView> implements JobView {
  late JobPresenter _presenter;
  List<JobEntry> _allJobs = [];
  List<JobEntry> _filteredJobs = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;
  final int _itemsPerPage = 20;
  int _currentnum = 20;
  final ScrollController _scrollController = ScrollController();
  Set<String> _favoriteJobs = {};
  CollectionReference? favoritesRef; // Nullable until initialized

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  // Initialize Firebase and setup favoritesRef
  void _initializeFirebase() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized
    favoritesRef = FirebaseFirestore.instance
        .collection('Login-Info')
        .doc(currentUserEmail)
        .collection('favorites');

    // After Firebase is initialized, load jobs
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
  void onJobsLoaded(List<JobEntry> jobs) {
    setState(() {
      _allJobs = jobs;
      _filteredJobs = jobs;
      _isLoading = false;
    });
    _loadFavorites(); // Load favorites after jobs are set
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  void _loadFavorites() async {
    if (favoritesRef == null) {
      return; // Return if favoritesRef is not yet initialized
    }

    final snapshot = await favoritesRef!.get();
    final favorites = snapshot.docs.map((doc) => doc.id).toSet();
    setState(() {
      _favoriteJobs = favorites;
      // Sync favorites with job entries
      for (var job in _allJobs) {
        job.isFavorite = _favoriteJobs.contains(job.id);
      }
      for (var job in _filteredJobs) {
        job.isFavorite = _favoriteJobs.contains(job.id);
      }
    });
  }

  void _filterJobs(String query) {
    final lowerQuery = query.toLowerCase();
    final results = _allJobs
        .where((job) => job.jobTitle.toLowerCase().contains(lowerQuery))
        .toList();
    setState(() {
      _searchQuery = query;
      _filteredJobs = results;
      _currentnum = _itemsPerPage.clamp(0, results.length);
    });
  }

  void _loadMoreJobs() {
    if (_currentnum < _filteredJobs.length) {
      setState(() {
        _currentnum =
            (_currentnum + _itemsPerPage).clamp(0, _filteredJobs.length);
      });
    }
  }

  void _toggleFavorite(JobEntry job) async {
    if (favoritesRef == null) {
      return; // Prevent any operation if favoritesRef is not initialized
    }

    final jobId = job.jobTitle;

    if (_favoriteJobs.contains(jobId)) {
      await favoritesRef!.doc(jobId).delete(); // Remove from Firestore
      setState(() {
        _favoriteJobs.remove(jobId); // Remove from local set
        job.isFavorite = false; // Update job state
      });
    } else {
      await favoritesRef!.doc(jobId).set({
        'Title': job.jobTitle,
        'company': job.company,
        'Company Score': job.companyScore,
        'location': job.location,
        'Date': job.date,
        'Salary': job.salary,
      }); // Add to Firestore
      setState(() {
        _favoriteJobs.add(jobId); // Add to local set
        job.isFavorite = true; // Update job state
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFavoriteIcon(JobEntry job) {
    final isFavorite = _favoriteJobs.contains(job.id);
    return isFavorite
        ? Stack(
      alignment: Alignment.center,
      children: const [
        Icon(Icons.star_border,
            color: Color.fromARGB(255, 151, 135, 8), size: 32),
        Icon(Icons.star,
            color: Color.fromARGB(255, 242, 201, 76), size: 24),
      ],
    )
        : const Icon(Icons.star_border, color: Colors.grey, size: 32);
  }

  TextStyle _descriptionTextStyle() {
    return const TextStyle(
      color: Color.fromARGB(255, 34, 124, 157),
      fontFamily: 'JetB',
      fontSize: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by job title',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterJobs,
            ),
          ),
          Expanded(
            child: _filteredJobs.isEmpty
                ? const Center(child: Text('No jobs found.'))
                : ListView.builder(
              controller: _scrollController,
              itemCount: _currentnum,
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
                        color: Color.fromARGB(255, 17, 84, 116),
                        fontFamily: 'JetB',
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
                          style: _descriptionTextStyle(),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Date Posted: ${job.date}',
                              style: _descriptionTextStyle(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Salary: ${job.salary}',
                              style: _descriptionTextStyle(),
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
