class JobEntry {
  final String company;
  final double companyScore;
  final String jobTitle;
  final String location;
  final String date;
  final String salary;

  JobEntry({
    required this.company,
    required this.companyScore,
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.salary,
  });

  factory JobEntry.fromMap(Map<String, dynamic> map) {
    return JobEntry(
      company: (map['Company'] ?? '').toString(),
      companyScore:
          double.tryParse((map['Company Score'] ?? '0.0').toString()) ?? 0.0,
      jobTitle: (map['Job Title'] ?? '').toString(),
      location: (map['Location'] ?? '').toString(),
      date: (map['Date'] ?? '').toString(),
      salary: (map['Salary'] ?? '').toString(),
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
