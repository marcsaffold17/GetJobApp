import '../view/homepage.dart';
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
                    title: Text('${job.jobTitle} @ ${job.jobTitle}'),
                    subtitle: Text(
                      'Score: ${job.salary} | ${job.companyLocation}',
                    ),
                  );
                },
              ),
    );
  }
}
