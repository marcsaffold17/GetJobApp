import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../model/SWE_List_model.dart';

abstract class JobView {
  void onJobsLoaded(List<JobEntry> jobs);
  void onError(String message);
}

class JobPresenter {
  final JobView view;

  JobPresenter(this.view);

  Future<void> loadJobsFromCSV(String assetPath) async {
    try {
      final rawData = await rootBundle.loadString(assetPath);
      print('Raw CSV Data: $rawData'); // Debug log

      // Parse the CSV with proper delimiter handling
      final rows = const CsvToListConverter().convert(
        rawData,
        fieldDelimiter: ',',
        eol: '\n',
        shouldParseNumbers: true,
        textDelimiter: '"',
      );
      print('Parsed CSV Rows: $rows'); // Debug log

      final headers = rows.first.cast<String>();
      final dataRows = rows.skip(1);

      // Add a log to print each data row individually
      for (var row in dataRows) {
        print('Row: $row');
      }

      final jobs =
          dataRows.map((row) {
            final map = Map<String, dynamic>.fromIterables(headers, row);
            return JobEntry.fromMap(map);
          }).toList();

      print('Jobs loaded: ${jobs.length}'); // Debug log
      view.onJobsLoaded(jobs);
    } catch (e) {
      print('Error loading jobs: $e');
      view.onError('Failed to load jobs: $e');
    }
  }
}
