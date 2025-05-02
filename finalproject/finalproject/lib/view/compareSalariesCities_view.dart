import 'package:flutter/material.dart';
import '../model/SWE_List_model.dart';

class CompareCitiesScreen extends StatelessWidget {
  final List<JobEntry> jobs;

  CompareCitiesScreen({required this.jobs});

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
    final cityJobMap = groupJobsByCity(jobs);
    final sortedCities = cityJobMap.entries.toList()
      ..sort((a, b) => averageSalary(b.value).compareTo(averageSalary(a.value)));

    return Scaffold(
      appBar: AppBar(title: Text('Average Salary By City')),
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      body: ListView.builder(
        itemCount: sortedCities.length,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          final city = sortedCities[index].key;
          final cityJobs = sortedCities[index].value;
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
    );
  }
}