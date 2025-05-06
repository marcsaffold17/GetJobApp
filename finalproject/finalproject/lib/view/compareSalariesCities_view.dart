import 'package:flutter/material.dart';
import '../model/SWE_List_model.dart';

class CompareCitiesScreen extends StatefulWidget {
  final List<JobEntry> jobs;

  const CompareCitiesScreen({super.key, required this.jobs});

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark
            ? const Color.fromARGB(255, 80, 80, 80)
            : const Color.fromARGB(255, 244, 243, 240);
    final cardColor =
        isDark
            ? const Color.fromARGB(255, 60, 60, 60)
            : const Color.fromARGB(255, 230, 230, 226);
    final titleColor =
        isDark ? Colors.white : const Color.fromARGB(255, 0, 43, 75);
    final subtitleColor =
        isDark
            ? const Color.fromARGB(255, 151, 151, 151)
            : const Color.fromARGB(255, 17, 84, 116);
    final highlightColor =
        isDark
            ? Colors.lightBlueAccent
            : const Color.fromARGB(255, 34, 124, 157);
    final inputFill =
        isDark
            ? const Color.fromARGB(100, 100, 100, 100)
            : const Color.fromARGB(40, 34, 124, 157);

    final cityJobMap = groupJobsByCity(widget.jobs);
    final sortedCities =
        cityJobMap.entries.toList()..sort(
          (a, b) => averageSalary(b.value).compareTo(averageSalary(a.value)),
        );

    final filteredCities =
        sortedCities
            .where(
              (entry) =>
                  entry.key.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 244, 243, 240),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Average Salary By City',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by city',
                labelStyle: TextStyle(
                  color: subtitleColor.withOpacity(0.8),
                  fontFamily: 'inter',
                ),
                filled: true,
                fillColor: inputFill,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: subtitleColor),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: highlightColor, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              style: TextStyle(color: subtitleColor, fontFamily: 'JetB'),
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
                  color: cardColor,
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
                    backgroundColor: cardColor,
                    title: Text(
                      city,
                      style: TextStyle(fontFamily: 'inter', color: titleColor),
                    ),
                    trailing: Text(
                      '\$${avgSalary.toStringAsFixed(1)}k',
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
                      ...cityJobs.map(
                        (job) => ListTile(
                          dense: true,
                          title: Text(
                            'Company: ${job.company}',
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          trailing: Text(
                            '\$${job.parsedSalary!.toStringAsFixed(1)}k',
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: highlightColor,
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
