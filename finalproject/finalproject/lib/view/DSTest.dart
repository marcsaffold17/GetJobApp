import '../presenter/DS_List_presenter.dart';
import '../model/DS_List_model.dart';
import 'package:flutter/material.dart';

class DJobListScreen extends StatefulWidget {
  const DJobListScreen({super.key});

  @override
  State<DJobListScreen> createState() => _DJobListScreenState();
}

class _DJobListScreenState extends State<DJobListScreen> implements JobView {
  late JobPresenter presenter;
  List<JobEntry> jobs = [];

  @override
  void initState() {
    super.initState();
    presenter = JobPresenter(this);
    presenter.loadJobsFromCSV('assets/datasets/DS-JAS.csv');
  }

  @override
  void onJobsLoaded(List<JobEntry> loadedJobs) {
    setState(() {
      jobs = loadedJobs;
    });
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 240),
      // appBar: AppBar(title: const Text('Jobs')),
      body:
          jobs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return ListTile(
                    tileColor: Colors.transparent,
                    title: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 226),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.jobTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'inter',
                              color: Color.fromARGB(255, 0, 43, 75),
                            ),
                          ),
                          Text(
                            "${job.jobCategory} | ${job.workYear}",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'JetB',
                              color: Color.fromARGB(255, 17, 84, 116),
                            ),
                          ),
                          Text(
                            'Company Size: ${job.companySize} | ${job.employeeResidence}\nSalary: ${job.salaryInUSD} | ${job.employmentType} | ${job.workSetting}',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'JetB',
                              color: Color.fromARGB(255, 17, 84, 116),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
