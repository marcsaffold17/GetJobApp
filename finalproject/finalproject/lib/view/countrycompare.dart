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
    return total / jobs.length / 1000;
  }

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Color variables based on theme
    final backgroundColor =
        isDark
            ? const Color.fromARGB(255, 80, 80, 80) // Dark background
            : const Color.fromARGB(255, 244, 243, 240); // Light background

    final cardColor =
        isDark
            ? const Color.fromARGB(255, 60, 60, 60) // Dark card color
            : const Color.fromARGB(255, 230, 230, 226); // Light card color

    final primaryTextColor = isDark ? Colors.white : Colors.black; // Text color
    final subtitleColor =
        isDark
            ? Colors.grey[300]! // Light grey subtitle text for dark mode
            : const Color.fromARGB(
              255,
              0,
              43,
              75,
            ); // Darker color for light mode

    final timeColor =
        isDark
            ? Colors
                .lightBlueAccent // Light blue for time in dark mode
            : const Color.fromARGB(
              255,
              34,
              124,
              157,
            ); // Different blue for light mode

    // Group and sort the jobs by country
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
          color: backgroundColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Average Salary By Country',
          style: TextStyle(fontFamily: 'inter', color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by country',
                labelStyle: TextStyle(
                  color: const Color.fromARGB(255, 34, 124, 157),
                  fontFamily: 'inter',
                ),
                filled: true,
                fillColor: const Color.fromARGB(40, 34, 124, 157),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 17, 84, 116),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 34, 124, 157),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
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
                      country,
                      style: TextStyle(
                        fontFamily: 'inter',
                        color: primaryTextColor,
                      ),
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
                      Divider(color: primaryTextColor, thickness: 1),
                      ...countryJobs.map(
                        (job) => ListTile(
                          dense: true,
                          title: Text(
                            'Company: ${job.jobTitle}',
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          trailing: Text(
                            '\$${(job.salaryInUSD / 1000).toStringAsFixed(1)}k',
                            style: TextStyle(
                              fontFamily: 'JetB',
                              fontSize: 12,
                              color: timeColor,
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
