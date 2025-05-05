import '../presenter/DS_List_presenter.dart';
import '../model/DS_List_model.dart';
import 'package:flutter/material.dart';

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
    // Check if the current theme is dark
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    // Define dark and light mode color schemes
    final backgroundColor =
        darkMode
            ? const Color.fromARGB(255, 80, 80, 80)
            : const Color.fromARGB(255, 244, 243, 240);
    final textColor =
        darkMode ? Colors.white : const Color.fromARGB(255, 17, 84, 116);
    final cardColor =
        darkMode
            ? const Color(0xFF333333)
            : const Color.fromARGB(255, 230, 230, 226);
    final inputBorderColor =
        darkMode ? Colors.white70 : const Color.fromARGB(255, 17, 84, 116);
    final focusedInputBorderColor =
        darkMode
            ? const Color(0xFF34d1ff)
            : const Color.fromARGB(255, 34, 124, 157);

    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Text(_errorMessage!, style: TextStyle(color: textColor)),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      style: TextStyle(color: textColor, fontFamily: 'JetB'),
                      decoration: InputDecoration(
                        labelText: 'Search by job category',
                        labelStyle: TextStyle(
                          color: inputBorderColor,
                          fontFamily: 'inter',
                        ),
                        filled: true,
                        fillColor:
                            darkMode
                                ? const Color(0xFF555555)
                                : const Color.fromARGB(40, 34, 124, 157),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: inputBorderColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: focusedInputBorderColor,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      onChanged: _filterJobs,
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredJobs.isEmpty
                            ? Center(
                              child: Text(
                                'No jobs found.',
                                style: TextStyle(color: textColor),
                              ),
                            )
                            : ListView.builder(
                              controller: _scrollController,
                              itemCount: _currentnum,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                return Card(
                                  color: cardColor,
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
                                    backgroundColor: cardColor,
                                    title: Text(
                                      job.jobTitle,
                                      style: TextStyle(
                                        fontFamily: 'inter',
                                        color:
                                            darkMode
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                  255,
                                                  0,
                                                  43,
                                                  75,
                                                ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${job.jobCategory} • ${job.employeeResidence}',
                                      style: TextStyle(
                                        color:
                                            darkMode
                                                ? Colors.white70
                                                : const Color.fromARGB(
                                                  255,
                                                  17,
                                                  84,
                                                  116,
                                                ),
                                        fontFamily: 'JetB',
                                      ),
                                    ),
                                    trailing: Text(
                                      job.formattedSalaryInUSD,
                                      style: TextStyle(
                                        color:
                                            darkMode
                                                ? Colors.white70
                                                : const Color.fromARGB(
                                                  255,
                                                  17,
                                                  84,
                                                  116,
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
                                              style: TextStyle(
                                                color:
                                                    darkMode
                                                        ? Colors.white70
                                                        : const Color.fromARGB(
                                                          255,
                                                          17,
                                                          84,
                                                          116,
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
    return TextStyle(
      color: const Color.fromARGB(255, 34, 124, 157),
      fontFamily: 'JetB',
      fontSize: 12,
    );
  }
}
