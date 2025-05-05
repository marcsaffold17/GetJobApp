import 'package:flutter/material.dart';
import '../model/DS_List_model.dart';

class CompareCountriesScreen extends StatefulWidget {
  final List<JobEntry> jobs;

  CompareCountriesScreen({required this.jobs});

  @override
  _CompareCountriesScreenState createState() => _CompareCountriesScreenState();
}

class _CompareCountriesScreenState extends State<CompareCountriesScreen> {
  String _searchQuery = '';

  Map<String, List<JobEntry>> groupJobsByCountry(List<JobEntry> jobs) {
    final Map<String, List<JobEntry>> countryJobMap = {};
    for (var job in jobs) {
      if (job.salaryInUSD > 0) {
        countryJobMap.putIfAbsent(job.companyLocation, () => []).add(job);
      }
    }
    return countryJobMap;
  }

  double averageSalary(List<JobEntry> jobs) {
    final total = jobs.map((j) => j.salaryInUSD).reduce((a, b) => a + b);
    return total / jobs.length / 1000; // convert to thousands for display
  }

  @override
  Widget build(BuildContext context) {
    final countryJobMap = groupJobsByCountry(widget.jobs);
    final sortedCountries =
        countryJobMap.entries.toList()..sort(
          (a, b) => averageSalary(b.value).compareTo(averageSalary(a.value)),
        );

    final filteredCountries =
        sortedCountries.where((entry) {
          return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 244, 243, 240),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Average Salary By Country',
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
                labelText: 'Search by country',
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
              itemCount: filteredCountries.length,
              padding: const EdgeInsets.all(12.0),
              itemBuilder: (context, index) {
                final country = filteredCountries[index].key;
                final countryJobs = filteredCountries[index].value;
                final avgSalary = averageSalary(countryJobs);

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
                      country,
                      style: const TextStyle(
                        fontFamily: 'inter',
                        color: Color.fromARGB(255, 0, 43, 75),
                      ),
                    ),
                    trailing: Text(
                      '\$${avgSalary.toStringAsFixed(1)}k',
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
                      ...countryJobs.map(
                        (job) => ListTile(
                          dense: true,
                          title: Text(
                            'Company: ${job.jobTitle}',
                            style: const TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: Color.fromARGB(255, 17, 84, 116),
                            ),
                          ),
                          trailing: Text(
                            '\$${(job.salaryInUSD / 1000).toStringAsFixed(1)}k',
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
        ],
      ),
    );
  }
}
