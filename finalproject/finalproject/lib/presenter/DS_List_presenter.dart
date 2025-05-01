import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../model/DS_List_model.dart';

abstract class JobView {
  void onJobsLoaded(List<JobEntry> jobs);
  void onError(String message);
}

class JobPresenter {
  final JobView view;
  List<JobEntry>? _cachedJobs;

  JobPresenter(this.view);

  Future<void> loadJobsFromCSV(String assetPath) async {
    if (_cachedJobs != null) {
      // print('Using cached jobs');
      view.onJobsLoaded(_cachedJobs!);
      return;
    }

    try {
      final rawData = await rootBundle.loadString(assetPath);
      // print('Raw CSV Data: $rawData'); // Debug log

      final rows = const CsvToListConverter().convert(
        rawData,
        fieldDelimiter: ',',
        eol: '\n',
        shouldParseNumbers: true,
        textDelimiter: '"',
      );
      // print('Parsed CSV Rows: $rows');

      final headers = rows.first.map((e) => e.toString().trim()).toList();
      final dataRows = rows.skip(1);

      final jobs =
          dataRows.map((row) {
            final map = Map<String, dynamic>.fromIterables(headers, row);
            return JobEntry.fromMap(map);
          }).toList();

      _cachedJobs = jobs;

      // print('Jobs loaded: ${jobs.length}');
      view.onJobsLoaded(jobs);
    } catch (e) {
      // print('Error loading jobs: $e');
      view.onError('Failed to load jobs: $e');
    }
  }
}
