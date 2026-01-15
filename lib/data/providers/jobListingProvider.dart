/*





import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/jobListModel.dart';

// StateProvider for accumulated job list
final jobListProvider = StateProvider<List<Job>>((ref) => []);

// StateProvider for total jobs
final totalJobsProvider = StateProvider<int>((ref) => 0);

// StateProvider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedTagProvider = StateProvider<String>((ref) => '');


// FutureProvider for fetching all job listings at once
final jobListingsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  // Fetch the first page to get total_jobs
  final firstPageResponse = await service.getJobListings("", "", "", "", "", "", 1, 10);
  if (firstPageResponse.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Initial fetch failed: ${firstPageResponse.response.statusCode}");
    throw Exception("Initial fetch failed");
  }

  final firstPageData = firstPageResponse.data;
  final totalJobs = firstPageData.totalJobs ?? 0;
  ref.read(totalJobsProvider.notifier).state = totalJobs;

  // Calculate total pages (limit is 10 jobs per page)
  final maxPages = (totalJobs / 10).ceil();

  // Fetch all pages concurrently
  final pageFutures = <Future<JobListModel>>[];
  for (int page = 1; page <= maxPages; page++) {
    pageFutures.add(
      service.getJobListings("", "", "", "", "", "", page, 10).then((response) {
        if (response.response.statusCode == 200) {
          return response.data;
        } else {
          throw Exception("Failed to fetch page $page");
        }
      }),
    );
  }

  try {
    final pageResults = await Future.wait(pageFutures);
    // Combine all jobs from all pages
    final allJobs = pageResults.fold<List<Job>>(
      [],
          (previous, result) => [...previous, ...result.jobs],
    );
    return allJobs;
  } catch (e) {
    Fluttertoast.showToast(msg: "Failed to fetch all jobs: $e");
    throw Exception("API Error: $e");
  }
});



final filteredJobListProvider = Provider<List<Job>>((ref) {
  final jobs = ref.watch(jobListProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedTag = ref.watch(selectedTagProvider).toLowerCase();

  return jobs.where((job) {
    final title = job.title.toLowerCase();
    final company = job.company.toLowerCase();
    final location = job.location.toLowerCase();
    final jobType = job.jobType?.toLowerCase() ?? '';

    final matchesSearch = searchQuery.isEmpty ||
        title.contains(searchQuery) ||
        company.contains(searchQuery) ||
        location.contains(searchQuery);

    final matchesTag = selectedTag.isEmpty || jobType.contains(selectedTag);

    return matchesSearch && matchesTag;
  }).toList();
});



*/

/*



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/jobListModel.dart';

// StateProvider for accumulated job list
final jobListProvider = StateProvider<List<Job>>((ref) => []);

// StateProvider for total jobs
final totalJobsProvider = StateProvider<int>((ref) => 0);

// StateProvider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedTagProvider = StateProvider<String>((ref) => '');

// FutureProvider for fetching all job listings at once
final jobListingsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  // Fetch all jobs in a single call without pagination
  final response = await service.getJobListings("", "", "", "", "", "", 1, 10); // Set limit to 0 to fetch all jobs
  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Fetch failed: ${response.response.statusCode}");
    throw Exception("Fetch failed");
  }

  final jobListData = response.data;
  final totalJobs = jobListData.totalJobs ?? 0;
  ref.read(totalJobsProvider.notifier).state = totalJobs;

  try {
    final allJobs = jobListData.jobs;
    return allJobs;
  } catch (e) {
    Fluttertoast.showToast(msg: "Failed to fetch jobs: $e");
    throw Exception("API Error: $e");
  }
});

final filteredJobListProvider = Provider<List<Job>>((ref) {
  final jobs = ref.watch(jobListProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedTag = ref.watch(selectedTagProvider).toLowerCase();

  return jobs.where((job) {
    final title = job.title!.toLowerCase();
    final company = job.company!.toLowerCase();
    final location = job.location!.toLowerCase();
    final jobType = job.jobType!.toLowerCase() ?? '';

    final matchesSearch = searchQuery.isEmpty ||
        title.contains(searchQuery) ||
        company.contains(searchQuery) ||
        location.contains(searchQuery);

    final matchesTag = selectedTag.isEmpty || jobType.contains(selectedTag);

    return matchesSearch && matchesTag;
  }).toList();
});*/



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/jobListModel.dart';

// StateProvider for accumulated job list
final jobListProvider = StateProvider<List<Job>>((ref) => []);

// StateProvider for total jobs
final totalJobsProvider = StateProvider<int>((ref) => 0);

// StateProvider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedTagProvider = StateProvider<String>((ref) => '');

// final selectedSpecialTagProvider = StateProvider<String>((ref) => '');

// FutureProvider for fetching all job listings at once
final jobListingsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  // Fetch all jobs in a single call without parameters
  final response = await service.getJobListings();
  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(
      msg: "Fetch failed: ${response.response.statusCode}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0,
    );
    throw Exception("Fetch failed");
  }

  final jobListData = response.data;
  // Handle missing totalJobs by using jobs array length
  final totalJobs = jobListData.totalJobs ?? jobListData.jobs.length;
  ref.read(totalJobsProvider.notifier).state = totalJobs;

  try {
    final allJobs = jobListData.jobs;
    if (allJobs == null || allJobs.isEmpty) {
      Fluttertoast.showToast(
        msg: "No jobs found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return [];
    }
    return allJobs;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Failed to fetch jobs: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0,
    );
    throw Exception("API Error: $e");
  }
});

final filteredJobListProvider = Provider<List<Job>>((ref) {

  final jobs = ref.watch(jobListProvider);


  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  final selectedTag = ref.watch(selectedTagProvider).toLowerCase();

  // final selectedTagSpecial = ref.watch(selectedSpecialTagProvider).toLowerCase();


  return jobs.where((job) {
    // Safely handle null fields with fallback to empty string
    final title = job.title?.toLowerCase() ?? '';
    final company = job.company?.toLowerCase() ?? '';
    final location = job.location?.toLowerCase() ?? '';
    final jobType = job.jobType?.toLowerCase() ?? '';

    final matchesSearch = searchQuery.isEmpty ||
        title.contains(searchQuery) ||
        company.contains(searchQuery) ||
        location.contains(searchQuery);

    final matchesTag = selectedTag.isEmpty || title.contains(selectedTag) || jobType.contains(selectedTag);
    // final matchesSpecialTag = selectedTagSpecial.isEmpty || jobType.contains(selectedTagSpecial);

    return matchesSearch && matchesTag;
  }).toList();
});