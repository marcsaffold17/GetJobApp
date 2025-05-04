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
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 244, 243, 240),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Average Salary by Company Size',
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
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by company size or job title',
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
                  color: const Color.fromARGB(255, 230, 230, 226),
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                    backgroundColor: const Color.fromARGB(255, 230, 230, 226),
                    title: Text(
                      sizeCategory,
                      style: const TextStyle(
                        fontFamily: 'inter',
                        color: Color.fromARGB(255, 0, 43, 75),
                      ),
                    ),
                    trailing: Text(
                      '\$${avgSalary.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'JetB',
                        fontSize: 12,
                        color: Color.fromARGB(255, 17, 84, 116),
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
                            style: const TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: Color.fromARGB(255, 17, 84, 116),
                            ),
                          ),
                          subtitle: Text(
                            '${job.jobCategory} • ${job.experienceLevel}',
                            style: const TextStyle(
                              fontFamily: 'inter',
                              fontSize: 11,
                              color: Color.fromARGB(255, 0, 43, 75),
                            ),
                          ),
                          trailing: Text(
                            job.formattedSalaryInUSD,
                            style: const TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: Color.fromARGB(255, 34, 124, 157),
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
                      color: Color.fromARGB(255, 0, 43, 75),
                    ),
                  ),
                  ..._selectedJobs.map(
                    (job) => Card(
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Text(
                          job.jobTitle,
                          style: TextStyle(
                            fontFamily: 'JetB',
                            fontSize: 13,
                            color: Colors.black87,
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
