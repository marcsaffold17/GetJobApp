import '../presenter/DS_List_presenter.dart';
import '../model/DS_List_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';
import 'countrycompare.dart';

class DJobListScreen extends StatefulWidget {
  const DJobListScreen({super.key});

  @override
  State<DJobListScreen> createState() => _DJobListScreenState();
}

class _DJobListScreenState extends State<DJobListScreen> implements JobView {
  late JobPresenter presenter;
  List<JobEntry> _allJobs = [];
  List<JobEntry> _filteredJobs = [];
  String _searchQuery = '';
  int _currentnum = 20;
  final int _itemsPerPage = 20;
  bool _isLoading = true;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

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
  void initState() {
    super.initState();
    presenter = JobPresenter(this);
    presenter.loadJobsFromCSV('assets/datasets/DS-JAS.csv');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreJobs();
      }
    });
  }

  @override
  void onJobsLoaded(List<JobEntry> loadedJobs) {
    setState(() {
      _allJobs = loadedJobs;
      _filteredJobs = loadedJobs;
      _currentnum = _itemsPerPage.clamp(0, loadedJobs.length);
      _isLoading = false;
      _errorMessage = null;
    });
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _filterJobs(String query) {
    final lowerQuery = query.toLowerCase();
    final results =
        _allJobs
            .where((job) => job.jobCategory.toLowerCase().contains(lowerQuery))
            .toList();
    setState(() {
      _searchQuery = query;
      _filteredJobs = results;
      _currentnum = _itemsPerPage.clamp(0, results.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 80, 80),
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
                      style: const TextStyle(
                        color: Color.fromARGB(255, 244, 243, 240),
                        fontFamily: 'JetB',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Search by job category',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(200, 244, 243, 240),
                          fontFamily: 'inter',
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(80, 0, 43, 75),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 43, 75),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 43, 75),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onChanged: _filterJobs,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CompareCountriesScreen(jobs: _filteredJobs),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 43, 75),
                      foregroundColor: const Color.fromARGB(255, 244, 243, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Compare Salaries by Country',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 12,
                        color: Color.fromARGB(255, 244, 243, 240),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredJobs.isEmpty
                            ? const Center(
                              child: Text(
                                'No jobs found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ListView.builder(
                              controller: _scrollController,
                              itemCount: _currentnum,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                return Card(
                                  color: const Color.fromARGB(
                                    255,
                                    100,
                                    100,
                                    100,
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
                                      100,
                                      100,
                                      100,
                                    ),
                                    title: Text(
                                      job.jobTitle,
                                      style: const TextStyle(
                                        fontFamily: 'inter',
                                        color: Color.fromARGB(255, 0, 43, 75),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${job.jobCategory} • ${job.employeeResidence}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          150,
                                          200,
                                          220,
                                        ),
                                        fontFamily: 'JetB',
                                      ),
                                    ),
                                    trailing: Text(
                                      job.formattedSalaryInUSD,
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          150,
                                          200,
                                          220,
                                        ),
                                        fontFamily: 'JetB',
                                        fontSize: 12,
                                      ),
                                    ),
                                    children: [
                                      const Divider(
                                        color: Color.fromARGB(255, 0, 43, 75),
                                        thickness: 2,
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Work Setting: ${job.workSetting}',
                                          style: _descriptionTextStyle(),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Employment Type: ${job.employmentType}',
                                              style: _descriptionTextStyle(),
                                            ),
                                            Text(
                                              'Work Year: ${job.workYear}',
                                              style: _descriptionTextStyle(),
                                            ),
                                            Text(
                                              'Company Size: ${job.companySize}',
                                              style: _descriptionTextStyle(),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Salary: ${job.formattedSalaryInUSD}',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  150,
                                                  200,
                                                  220,
                                                ),
                                                fontFamily: 'JetB',
                                              ),
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

  TextStyle _descriptionTextStyle() {
    return const TextStyle(
      color: Color.fromARGB(255, 150, 200, 220),
      fontFamily: 'JetB',
      fontSize: 12,
    );
  }
}
