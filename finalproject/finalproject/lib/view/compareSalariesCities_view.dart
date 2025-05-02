import 'package:flutter/material.dart';
import '../model/SWE_List_model.dart';

class CompareCitiesScreen extends StatefulWidget {
  final List<JobEntry> jobs;

  CompareCitiesScreen({required this.jobs});

  @override
  _CompareCitiesScreenState createState() => _CompareCitiesScreenState();
}

  class _CompareCitiesScreenState extends State<CompareCitiesScreen> {
  String _searchQuery = '';

  Map<String, List<JobEntry>> groupJobsByCity(List<JobEntry> jobs) {
    final Map<String, List<JobEntry>> cityJobMap = {};
    for (var job in jobs) {
      if (job.parsedSalary != null) {
        cityJobMap.putIfAbsent(job.location, () => []).add(job);
      }
    }
    return cityJobMap;
  }

  double averageSalary(List<JobEntry> jobs) {
    final total = jobs.map((j) => j.parsedSalary!).reduce((a, b) => a + b);
    return total / jobs.length;
  }

  @override
  Widget build(BuildContext context) {
    final cityJobMap = groupJobsByCity(widget.jobs);
    final sortedCities = cityJobMap.entries.toList()
      ..sort((a, b) => averageSalary(b.value).compareTo(averageSalary(a.value)));

    final filteredCities = sortedCities.where((entry) {
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
        title: Text(
          'Average Salary By City',
          style: TextStyle(
            fontFamily: 'inter',
            color: Color.fromARGB(255, 244, 243, 240),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        )
      ),
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by city',
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
              itemCount: filteredCities.length,
              padding: const EdgeInsets.all(12.0),
              itemBuilder: (context, index) {
                final city = filteredCities[index].key;
                final cityJobs = filteredCities[index].value;
                final avgSalary = averageSalary(cityJobs);

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
                      city,
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
                      ...cityJobs.map((job) => ListTile(
                        dense: true,
                        title: Text(
                          'Company: ${job.company}',
                          style: const TextStyle(
                            fontFamily: 'JetB',
                            fontSize: 12,
                            color: Color.fromARGB(255, 17, 84, 116),
                          ),
                        ),
                        trailing: Text(
                          '\$${job.parsedSalary!.toStringAsFixed(1)}k',
                          style: const TextStyle(
                            fontFamily: 'JetB',
                            fontSize: 12,
                            color: Color.fromARGB(255, 34, 124, 157),
                          ),
                        ),
                      )),
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