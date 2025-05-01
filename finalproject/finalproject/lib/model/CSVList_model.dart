class User {
  final String company;
  final int company_score;
  final String job_title;
  final String location;
  final String date;
  final String salary;

  User({
    required this.company,
    required this.company_score,
    required this.job_title,
    required this.location,
    required this.date,
    required this.salary,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      company: map['Company'].toString(),
      company_score: int.tryParse(map['Company Score'].toString()) ?? 0,
      job_title: map['Job Title'].toString(),
      location: map['Location'].toString(),
      date: map['Date'].toString(),
      salary: map['Salary'].toString(),
    );
  }
}
