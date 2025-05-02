class JobEntry {
  final String id;
  final String company;
  final double companyScore;
  final String jobTitle;
  final String location;
  final String date;
  final String salary;
  bool isFavorite = false;

  JobEntry({
    required this.id,
    required this.company,
    required this.companyScore,
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.salary,
    required bool isFavorite,

  });

  factory JobEntry.fromMap(Map<String, dynamic> map,  {required String id}) {
    return JobEntry(
      id: id,
      company: (map['Company'] ?? '').toString(),
      companyScore:
          double.tryParse((map['Company Score'] ?? '0.0').toString()) ?? 0.0,
      jobTitle: (map['Job Title'] ?? '').toString(),
      location: (map['Location'] ?? '').toString(),
      date: (map['Date'] ?? '').toString(),
      salary: (map['Salary'] ?? '').toString(),
      isFavorite: false,
    );
  }
}

extension JobEntrySalaryExtension on JobEntry {
  String get salaryRange {
    final parts = salary.split('(');
    return parts.first.trim();
  }

  String get salarySource {
    final parts = salary.split('(');
    return parts.length > 1 ? '(${parts[1].trim()}' : '';
  }
}

// Averages out the salary for every city on spreadsheet
extension ParsedSalary on JobEntry {
  double? get parsedSalary {
    final numeric = RegExp(r'[\d,]+').allMatches(salary).map((m) {
      return m.group(0)!.replaceAll(',', '');
    }).toList();

    if (numeric.isEmpty) return null;

    final values = numeric.map(double.tryParse).whereType<double>().toList();
    if (values.isEmpty) return null;

    return values.length == 2 ? (values[0] + values[1]) / 2 : values[0];
  }
}