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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = JobPresenter(this);
    // TODO: Load jobs from CSV here
  }

  @override
  void onJobsLoaded(List<JobEntry> jobs) {
    // TODO: Set the job lists and stop loading
  }

  @override
  void onError(String message) {
    // TODO: Handle error by setting _errorMessage and updating UI
  }

  void _filterJobs(String query) {
    // TODO: Implement filtering logic for job titles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search SWE Jobs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by job title',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // TODO: Call _filterJobs here
              },
            ),
          ),
          // TODO: Display loading spinner, error message, or job list here
        ],
      ),
    );
  }
}
