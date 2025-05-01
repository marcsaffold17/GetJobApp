import 'package:flutter/material.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';

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

  @override
  void initState() {
    super.initState();
    _presenter = JobPresenter(this);
    _presenter.loadJobsFromCSV('assets/datasets/SWE-JAS.csv'); // Update path if needed
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Software Engineering Jobs'),
      ),
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
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return ListTile(
                  title: Text(job.jobTitle),
                  subtitle:
                  Text('${job.company} • ${job.location}'),
                  trailing: Text(job.salary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

