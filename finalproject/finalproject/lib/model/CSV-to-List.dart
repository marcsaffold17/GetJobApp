import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

Future<List<Map<String, dynamic>>> loadCsvAsMaps(String path) async {
  final rawData = await rootBundle.loadString(path);
  final rows = const CsvToListConverter().convert(rawData);

  final headers = rows.first.cast<String>();
  final dataRows = rows.skip(1);

  return dataRows.map((row) {
    return Map<String, dynamic>.fromIterables(headers, row);
  }).toList();
}
