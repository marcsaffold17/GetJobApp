import '../presenter/DS_List_presenter.dart';
import '../model/DS_List_model.dart';
import '../view/CompanyCompare.dart';
import '../view/countrycompare.dart'; // Make sure this import matches your file path
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
  Set<String> _favoriteJobIds = {};
  String _searchQuery = '';
  int _currentnum = 20;
  final int _itemsPerPage = 20;
  bool _isLoading = true;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalEmail)
      .collection('favorites');

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
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    final ids = snapshot.docs.map((doc) => doc.id).toSet();

    setState(() {
      _favoriteJobIds = ids;

      for (var job in _filteredJobs) {
        final jobId = job.jobTitle + job.jobCategory + job.employeeResidence;
        job.isFavorite = _favoriteJobIds.contains(jobId);
      }

      for (var job in _allJobs) {
        final jobId = job.jobTitle + job.jobCategory + job.employeeResidence;
        job.isFavorite = _favoriteJobIds.contains(jobId);
      }
    });
  }

  void _toggleFavorite(JobEntry job) async {
    final jobId = job.jobTitle + job.jobCategory + job.employeeResidence;

    if (_favoriteJobIds.contains(jobId)) {
      await favoritesRef.doc(jobId).delete();
      setState(() {
        _favoriteJobIds.remove(jobId);
        job.isFavorite = false;
      });
    } else {
      await favoritesRef.doc(jobId).set({
        'Title': job.jobTitle,
        'Category': job.jobCategory,
        'Work Setting': job.workSetting,
        'Employment Type': job.employmentType,
        'Location': job.employeeResidence,
        'Year': job.workYear,
        'Salary': job.formattedSalaryInUSD,
        'Size': job.companySize,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDark
            ? const Color.fromARGB(255, 80, 80, 80)
            : const Color.fromARGB(255, 244, 243, 240);

    final cardColor =
        isDark
            ? const Color.fromARGB(255, 100, 100, 100)
            : const Color.fromARGB(255, 230, 230, 226);

    final titleColor =
        isDark
            ? const Color.fromARGB(255, 220, 220, 220)
            : const Color.fromARGB(255, 0, 43, 75);

    final subtitleColor =
        isDark
            ? const Color.fromARGB(255, 150, 200, 220)
            : const Color.fromARGB(255, 17, 84, 116);

    final subsubtitleColor =
        isDark
            ? const Color.fromARGB(255, 150, 200, 220)
            : const Color.fromARGB(255, 34, 124, 157);

    final fillColor =
        isDark
            ? const Color(0xFF555555)
            : const Color.fromARGB(40, 34, 124, 157);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                      style: TextStyle(color: titleColor, fontFamily: 'JetB'),
                      decoration: InputDecoration(
                        labelText: 'Search by job category',
                        labelStyle: TextStyle(
                          color: subtitleColor.withAlpha(200),
                          fontFamily: 'inter',
                        ),
                        filled: true,
                        fillColor: fillColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: titleColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: titleColor, width: 2.0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      onChanged: _filterJobs,
                    ),
                  ),

                  // Button for Compare Salaries by Country
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
                      backgroundColor: const Color(0xFF002B4B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Compare Salaries by Country',
                      style: TextStyle(fontFamily: 'inter', fontSize: 12),
                    ),
                  ),

                  // New Button for Compare Companies by Size
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CompareCompaniesBySizeScreen(
                                jobs: _filteredJobs,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002B4B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Compare Salaries by Company Size',
                      style: TextStyle(fontFamily: 'inter', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dataset Credit: Hummaam Qaasim - Kaggle',
                    style: _descriptionTextStyle(
                      subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child:
                        _filteredJobs.isEmpty
                            ? Center(
                              child: Text(
                                'No jobs found.',
                                style: TextStyle(color: subtitleColor),
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
                                        color: titleColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${job.jobCategory} • ${job.employeeResidence}',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontFamily: 'JetB',
                                      ),
                                    ),
                                    trailing: Text(
                                      job.formattedSalaryInUSD,
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontFamily: 'JetB',
                                        fontSize: 12,
                                      ),
                                    ),
                                    children: [
                                      Divider(color: titleColor, thickness: 2),
                                      ListTile(
                                        title: Text(
                                          'Work Setting: ${job.workSetting}',
                                          style: _descriptionTextStyle(
                                            subsubtitleColor,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: _buildFavoriteIcon(job),
                                          onPressed: () => _toggleFavorite(job),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Employment Type: ${job.employmentType}',
                                              style: _descriptionTextStyle(
                                                subsubtitleColor,
                                              ),
                                            ),
                                            Text(
                                              'Work Year: ${job.workYear}',
                                              style: _descriptionTextStyle(
                                                subsubtitleColor,
                                              ),
                                            ),
                                            Text(
                                              'Company Size: ${job.companySize}',
                                              style: _descriptionTextStyle(
                                                subsubtitleColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Salary: ${job.formattedSalaryInUSD}',
                                              style: TextStyle(
                                                color: subtitleColor,
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

  TextStyle _descriptionTextStyle(Color subtitleColor) {
    return TextStyle(color: subtitleColor, fontFamily: 'JetB', fontSize: 12);
  }
}
