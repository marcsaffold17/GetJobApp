import 'package:flutter/material.dart';
import '../globals/user_info.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(currentUserEmail)
      .collection('favorites');

  @override
  void initState() {
    super.initState();
    _presenter = JobPresenter(this);
    _loadFavorites();
    _presenter.loadJobsFromCSV('assets/datasets/SWE-JAS.csv');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreJobs();
      }
    });
  }

  void _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    setState(() {
      _favoriteJobs = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  @override
  void onJobsLoaded(List<JobEntry> jobs) {
    setState(() {
      _allJobs = jobs;
      _filteredJobs = jobs;
      _isLoading = false;
    });
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
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
    final jobId = job.jobTitle;

    if (_favoriteJobs.contains(jobId)) {
      await favoritesRef.doc(jobId).delete();
      setState(() {
        _favoriteJobs.remove(jobId);
      });
    } else {
      await favoritesRef.doc(jobId).set({
        'jobTitle': job.jobTitle,
        'company': job.company,
        'location': job.location,
        'date': job.date,
        'salary': job.salary,
        'companyScore': job.companyScore,
      });
      setState(() {
        _favoriteJobs.add(jobId);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text(
                      job.jobTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${job.company} • ${job.location}'),
                    children: [
                      ListTile(
                        title: Text(
                            'Company Score: ${job.companyScore}'),
                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Date Posted: ${job.date}'),
                            const SizedBox(height: 8),
                            Text('Salary: ${job.salary}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            _favoriteJobs
                                .contains(job.jobTitle)
                                ? Icons.star
                                : Icons.star_border,
                            color: _favoriteJobs
                                .contains(job.jobTitle)
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () =>
                              _toggleFavorite(job),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
