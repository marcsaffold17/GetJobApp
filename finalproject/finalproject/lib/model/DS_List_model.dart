class JobEntry {
  final int workYear;
  final String jobTitle;
  final String jobCategory;
  final String salaryCurrency;
  final int salary;
  final int salaryInUSD;
  final String employeeResidence;
  final String experienceLevel;
  final String employmentType;
  final String workSetting;
  final String companyLocation;
  final String companySize;

  JobEntry({
    required this.workYear,
    required this.jobTitle,
    required this.jobCategory,
    required this.salaryCurrency,
    required this.salary,
    required this.salaryInUSD,
    required this.employeeResidence,
    required this.experienceLevel,
    required this.employmentType,
    required this.workSetting,
    required this.companyLocation,
    required this.companySize,
  });

  factory JobEntry.fromMap(Map<String, dynamic> map) {
    return JobEntry(
      workYear: int.tryParse((map['work_year'] ?? '0').toString()) ?? 0,
      jobTitle: (map['job_title'] ?? '').toString(),
      jobCategory: (map['job_category'] ?? '').toString(),
      salaryCurrency: (map['salary_currency'] ?? '').toString(),
      salary: int.tryParse((map['salary'] ?? '0').toString()) ?? 0,
      salaryInUSD: int.tryParse((map['salary_in_usd'] ?? '0').toString()) ?? 0,
      employeeResidence: (map['employee_residence'] ?? '').toString(),
      experienceLevel: (map['experience_level'] ?? '').toString(),
      employmentType: (map['employment_type'] ?? '').toString(),
      workSetting: (map['work_setting'] ?? '').toString(),
      companyLocation: (map['company_location'] ?? '').toString(),
      companySize: (map['company_size'] ?? '').toString(),
    );
  }
}
