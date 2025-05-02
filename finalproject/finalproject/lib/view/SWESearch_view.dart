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
  final int _itemsPerPage = 20;
  int _currentnum = 20;
  final ScrollController _scrollController = ScrollController();

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
    final results =
        _allJobs
            .where((job) => job.jobTitle.toLowerCase().contains(lowerQuery))
            .toList();
    setState(() {
      _searchQuery = query;
      _filteredJobs = results;
      _currentnum = _itemsPerPage.clamp(0, results.length);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreJobs() {
    if (_currentnum < _filteredJobs.length) {
      setState(() {
        _currentnum = (_currentnum + _itemsPerPage).clamp(
          0,
          _filteredJobs.length,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 240),
      body:
          _isLoading
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
                    child:
                        _filteredJobs.isEmpty
                            ? const Center(child: Text('No jobs found.'))
                            : ListView.builder(
                              controller: _scrollController,
                              itemCount: _currentnum,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                return Card(
                                  color: Color.fromARGB(255, 230, 230, 226),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: ExpansionTile(
                                    backgroundColor: Color.fromARGB(
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
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 17, 84, 116),
                                        fontFamily: 'JetB',
                                      ),
                                    ),
                                    trailing: Text(
                                      job.salaryRange,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 17, 84, 116),
                                        fontFamily: 'JetB',
                                        fontSize: 10,
                                      ),
                                    ),
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'Company Score: ${job.companyScore}',
                                          style: DescriptionTStyle(),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              'Date Posted: ${job.date}',
                                              style: DescriptionTStyle(),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Salary: ${job.salary}',
                                              style: DescriptionTStyle(),
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

  TextStyle DescriptionTStyle() {
    return TextStyle(
      color: Color.fromARGB(255, 34, 124, 157),
      fontFamily: 'JetB',
      fontSize: 12,
    );
  }
}
