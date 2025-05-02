import 'package:flutter/material.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';

class CompareCitiesScreen extends StatelessWidget {
  final List<JobEntry> jobs;

  CompareCitiesScreen({required this.jobs});

  Map<String, double> computeAverageSalaryByCity(List<JobEntry> jobs) {
    final Map<String, List<double>> citySalaries = {};

    for (var job in jobs) {
      final salary = job.parsedSalary;
      if (salary != null) {
        citySalaries.putIfAbsent(job.location, () => []).add(salary);
      }
    }

    return citySalaries.map((city, salaries) {
      final average = salaries.reduce((a, b) => a + b) / salaries.length;
      return MapEntry(city, average);
    });
  }

  @override
  Widget build(BuildContext context) {
    final citySalaryMap = computeAverageSalaryByCity(jobs);
    final sortedCities = citySalaryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: Text('Average Salary By City')),
      body: ListView.builder(
        itemCount: sortedCities.length,
        itemBuilder: (context, index) {
          final entry = sortedCities[index];
          return ListTile(
            title: Text(entry.key),
            trailing: Text('\$${entry.value.toStringAsFixed(1)}k'),
          );
        },
      ),
    );
  }
}