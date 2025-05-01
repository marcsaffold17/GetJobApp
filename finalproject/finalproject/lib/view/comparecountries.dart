import 'package:flutter/material.dart';
import '../model/DS_List_model.dart';
import '../presenter/DS_List_presenter.dart';

class JobComparePage extends StatefulWidget {
  const JobComparePage({Key? key}) : super(key: key);

  @override
  State<JobComparePage> createState() => _JobComparePageState();
}

class _JobComparePageState extends State<JobComparePage> implements JobView {
  late JobPresenter presenter;
  List<JobEntry> jobs = [];
  bool isLoading = true;

  String? selectedCountryA;
  String? selectedJobA;
  String? selectedCountryB;
  String? selectedJobB;

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
      isLoading = false;
    });
  }

  @override
  void onError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  JobEntry getJob(String? title, String? country) {
    return jobs.firstWhere(
      (job) => job.jobTitle == title && job.companyLocation == country,
      orElse:
          () => JobEntry(
            workYear: 0,
            jobTitle: 'Unknown',
            jobCategory: '',
            salaryCurrency: '',
            salary: 0,
            salaryInUSD: 0,
            employeeResidence: '',
            experienceLevel: '',
            employmentType: '',
            workSetting: '',
            companyLocation: '',
            companySize: '',
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final countries =
        jobs.map((job) => job.companyLocation).toSet().toList()..sort();

    List<String> jobTitlesForCountry(String? country) {
      return jobs
          .where((job) => job.companyLocation == country)
          .map((job) => job.jobTitle)
          .toSet()
          .toList()
        ..sort();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Job Salaries by Country')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSelector(
              'Job A',
              countries,
              selectedCountryA,
              (val) => setState(() {
                selectedCountryA = val;
                selectedJobA = null;
              }),
              jobTitlesForCountry(selectedCountryA),
              selectedJobA,
              (val) => setState(() => selectedJobA = val),
            ),
            const SizedBox(height: 24),
            _buildSelector(
              'Job B',
              countries,
              selectedCountryB,
              (val) => setState(() {
                selectedCountryB = val;
                selectedJobB = null;
              }),
              jobTitlesForCountry(selectedCountryB),
              selectedJobB,
              (val) => setState(() => selectedJobB = val),
            ),
            const SizedBox(height: 32),
            if (selectedCountryA != null &&
                selectedJobA != null &&
                selectedCountryB != null &&
                selectedJobB != null)
              _buildComparison(
                getJob(selectedJobA, selectedCountryA),
                getJob(selectedJobB, selectedCountryB),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(
    String label,
    List<String> countryOptions,
    String? selectedCountry,
    ValueChanged<String?> onCountryChanged,
    List<String> jobOptions,
    String? selectedJob,
    ValueChanged<String?> onJobChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCountry,
                hint: const Text('Select Country'),
                onChanged: onCountryChanged,
                items:
                    countryOptions.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedJob,
                hint: const Text('Select Job'),
                onChanged: jobOptions.isNotEmpty ? onJobChanged : null,
                items:
                    jobOptions.map((job) {
                      return DropdownMenuItem(value: job, child: Text(job));
                    }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparison(JobEntry jobA, JobEntry jobB) {
    final diff = (jobA.salaryInUSD - jobB.salaryInUSD).abs();
    final comparison =
        jobA.salaryInUSD == jobB.salaryInUSD
            ? "Both jobs pay the same."
            : jobA.salaryInUSD > jobB.salaryInUSD
            ? "${jobA.jobTitle} in ${jobA.companyLocation} pays \$${diff} more than ${jobB.jobTitle} in ${jobB.companyLocation}."
            : "${jobB.jobTitle} in ${jobB.companyLocation} pays \$${diff} more than ${jobA.jobTitle} in ${jobA.companyLocation}.";

    return Column(
      children: [
        Text(
          "${jobA.jobTitle} (${jobA.companyLocation}) - \$${jobA.salaryInUSD}",
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          "${jobB.jobTitle} (${jobB.companyLocation}) - \$${jobB.salaryInUSD}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Text(
          comparison,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
