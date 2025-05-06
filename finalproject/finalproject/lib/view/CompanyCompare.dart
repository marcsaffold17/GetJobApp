import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../model/DS_List_model.dart';

class CompareCompaniesBySizeScreen extends StatefulWidget {
  final List<JobEntry> jobs;

  CompareCompaniesBySizeScreen({required this.jobs});

  @override
  _CompareCompaniesBySizeScreenState createState() =>
      _CompareCompaniesBySizeScreenState();
}

class _CompareCompaniesBySizeScreenState
    extends State<CompareCompaniesBySizeScreen> {
  String _searchQuery = '';
  late List<JobEntry> _jobs;
  List<JobEntry> _selectedJobs = [];

  @override
  void initState() {
    super.initState();
    _jobs = widget.jobs;
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final rawData = await rootBundle.loadString('assets/datasets/DS-JAS.csv');
    List<List<dynamic>> csvData = CsvToListConverter().convert(rawData);

    List<JobEntry> jobEntries = [];

    for (var row in csvData) {
      if (row.isNotEmpty) {
        var job = JobEntry(
          workYear: int.tryParse(row[0].toString()) ?? 0,
          jobTitle: row[1].toString(),
          jobCategory: row[2].toString(),
          salaryCurrency: row[3].toString(),
          salary: int.tryParse(row[4].toString()) ?? 0,
          salaryInUSD: int.tryParse(row[5].toString()) ?? 0,
          employeeResidence: row[6].toString(),
          experienceLevel: row[7].toString(),
          employmentType: row[8].toString(),
          workSetting: row[9].toString(),
          companyLocation: row[10].toString(),
          companySize: row[11].toString(),
          isFavorite: false,
        );
        jobEntries.add(job);
      }
    }

    setState(() {
      _jobs = jobEntries;
    });
  }

  String getSizeLabel(String sizeCode) {
    switch (sizeCode.toUpperCase().trim()) {
      case 'S':
        return 'Small';
      case 'M':
        return 'Medium';
      case 'L':
        return 'Large';
      default:
        return 'Unknown';
    }
  }

  Map<String, List<JobEntry>> groupJobsByCompanySize(List<JobEntry> jobs) {
    final Map<String, List<JobEntry>> sizeJobMap = {};
    for (var job in jobs) {
      final label = getSizeLabel(job.companySize);
      if (job.salaryInUSD > 0 && label != 'Unknown') {
        sizeJobMap.putIfAbsent(label, () => []).add(job);
      }
    }
    return sizeJobMap;
  }

  double averageSalary(List<JobEntry> jobs) {
    final total = jobs.fold<int>(0, (sum, j) => sum + j.salaryInUSD);
    return total / jobs.length;
  }

  void _toggleJobSelection(JobEntry job) {
    setState(() {
      if (_selectedJobs.contains(job)) {
        _selectedJobs.remove(job);
      } else {
        if (_selectedJobs.length < 2) {
          _selectedJobs.add(job);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can compare up to 2 jobs only.')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Dark and light mode color settings
    final Color backgroundColor =
        isDarkMode
            ? const Color.fromARGB(255, 80, 80, 80) // Dark background
            : const Color.fromARGB(255, 244, 243, 240); // Light background

    final Color appBarColor =
        isDarkMode
            ? const Color.fromARGB(255, 0, 43, 75) // Dark app bar
            : const Color.fromARGB(255, 0, 43, 75); // Light app bar

    final Color cardColor =
        isDarkMode
            ? const Color.fromARGB(255, 60, 60, 60) // Dark card color
            : const Color.fromARGB(255, 230, 230, 226); // Light card color

    final Color titleColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 0, 43, 75);
    final Color subtitleColor =
        isDarkMode
            ? const Color.fromARGB(255, 151, 151, 151)
            : const Color.fromARGB(255, 17, 84, 116);

    final sizeJobMap = groupJobsByCompanySize(_jobs);
    final sortedSizes =
        sizeJobMap.entries.toList()..sort(
          (a, b) => averageSalary(b.value).compareTo(averageSalary(a.value)),
        );

    final query = _searchQuery.toLowerCase().trim();

    final filteredSizes =
        sortedSizes
            .map((entry) {
              final filteredJobs =
                  entry.value.where((job) {
                    final sizeMatch = entry.key.toLowerCase().contains(query);
                    final titleMatch = job.jobTitle.toLowerCase().contains(
                      query,
                    );
                    return sizeMatch || titleMatch;
                  }).toList();
              return MapEntry(entry.key, filteredJobs);
            })
            .where((entry) => entry.value.isNotEmpty)
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: titleColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'company size vs salary',
          style: TextStyle(
            fontFamily: 'inter',
            color: Color.fromARGB(255, 244, 243, 240),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by company size or job title',
                labelStyle: TextStyle(color: subtitleColor),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSizes.length,
              padding: const EdgeInsets.all(12.0),
              itemBuilder: (context, index) {
                final sizeCategory = filteredSizes[index].key;
                final sizeJobs = filteredSizes[index].value;
                final avgSalary = averageSalary(sizeJobs);

                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: cardColor,
                    title: Text(
                      sizeCategory,
                      style: TextStyle(fontFamily: 'inter', color: titleColor),
                    ),
                    trailing: Text(
                      '\$${avgSalary.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontFamily: 'JetB',
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 0, 43, 75),
                        thickness: 1,
                      ),
                      ...sizeJobs.map(
                        (job) => ListTile(
                          dense: true,
                          onTap: () => _toggleJobSelection(job),
                          selected: _selectedJobs.contains(job),
                          selectedTileColor: Colors.blue.shade50,
                          leading: Checkbox(
                            value: _selectedJobs.contains(job),
                            onChanged: (_) => _toggleJobSelection(job),
                          ),
                          title: Text(
                            'Job: ${job.jobTitle}',
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          subtitle: Text(
                            '${job.jobCategory} • ${job.experienceLevel}',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 11,
                              color: titleColor,
                            ),
                          ),
                          trailing: Text(
                            job.formattedSalaryInUSD,
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_selectedJobs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Job Comparison:',
                    style: TextStyle(
                      fontFamily: 'JetB',
                      fontSize: 14,
                      color: titleColor,
                    ),
                  ),
                  ..._selectedJobs.map(
                    (job) => Card(
                      color: cardColor,
                      child: ListTile(
                        title: Text(
                          job.jobTitle,
                          style: TextStyle(
                            fontFamily: 'JetB',
                            fontSize: 13,
                            color: titleColor,
                          ),
                        ),
                        subtitle: Text(
                          '${job.jobCategory} • ${job.experienceLevel} • ${getSizeLabel(job.companySize)}',
                        ),
                        trailing: Text(
                          job.formattedSalaryInUSD,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
