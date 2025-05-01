import '../view/homepage.dart';
import '../presenter/SWE_List_presenter.dart';
import '../model/SWE_List_model.dart';
import 'package:flutter/material.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> implements JobView {
  late JobPresenter presenter;
  List<JobEntry> jobs = [];

  @override
  void initState() {
    super.initState();
    presenter = JobPresenter(this);
    presenter.loadJobsFromCSV('assets/datasets/SWE-JAS.csv');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      body:
          jobs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return ListTile(
                    title: Text('${job.jobTitle} @ ${job.company}'),
                    subtitle: Text(
                      'Score: ${job.companyScore} | ${job.location}',
                    ),
                  );
                },
              ),
    );
  }
}
