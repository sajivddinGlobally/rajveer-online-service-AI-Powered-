/*
// To parse this JSON data, do
//
//     final jobListModel = jobListModelFromJson(jsonString);

import 'dart:convert';
JobListModel jobListModelFromJson(String str) => JobListModel.fromJson(json.decode(str));
String jobListModelToJson(JobListModel data) => json.encode(data.toJson());
class JobListModel {
  List<Job> jobs;
  int totalJobs;
  int page;
  JobListModel({
    required this.jobs,
    required this.totalJobs,
    required this.page,
  });
  factory JobListModel.fromJson(Map<String, dynamic> json) => JobListModel(
    jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
    totalJobs: json["total_jobs"],
    page: json["page"],
  );
  Map<String, dynamic> toJson() => {
    "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
    "total_jobs": totalJobs,
    "page": page,
  };
}

class Job {
  int? jobId;
  String? title;
  String? company;
  String? location;
  String? jobType;
  dynamic minExperience;
  dynamic maxExperience;
  dynamic salaryMin;
  dynamic salaryMax;
  DateTime? postedDate;

  Job({
     this.jobId,
     this.title,
     this.company,
     this.location,
     this.jobType,
     this.minExperience,
     this.maxExperience,
     this.salaryMin,
     this.salaryMax,
     this.postedDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    jobId: json["job_id"],
    title: json["title"],
    company: json["company"],
    location: json["location"],
    jobType: json["job_type"],
    minExperience: json["min_experience"],
    maxExperience: json["max_experience"],
    salaryMin: json["salary_min"],
    salaryMax: json["salary_max"],
    postedDate: json["posted_date"] != null ? DateTime.parse(json["posted_date"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "job_id": jobId,
    "title": title,
    "company": company,
    "location": location,
    "job_type": jobType,
    "min_experience": minExperience,
    "max_experience": maxExperience,
    "salary_min": salaryMin,
    "salary_max": salaryMax,
    "posted_date": postedDate != null
        ? "${postedDate!.year.toString().padLeft(4, '0')}-${postedDate!.month.toString().padLeft(2, '0')}-${postedDate!.day.toString().padLeft(2, '0')}"
        : null, };
}



*/







import 'dart:convert';
JobListModel jobListModelFromJson(String str) => JobListModel.fromJson(json.decode(str));
String jobListModelToJson(JobListModel data) => json.encode(data.toJson());
class JobListModel {
  List<Job> jobs;
  int? totalJobs; // Nullable to handle missing field
  int? page; // Nullable to handle missing field

  JobListModel({
    required this.jobs,
    this.totalJobs,
    this.page,
  });

  factory JobListModel.fromJson(Map<String, dynamic> json) => JobListModel(
    jobs: (json["jobs"] as List<dynamic>?)?.map((x) => Job.fromJson(x as Map<String, dynamic>)).toList() ?? [],
    totalJobs: json["total_jobs"] as int?, // Allow null
    page: json["page"] as int?, // Allow null
  );

  Map<String, dynamic> toJson() => {
    "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
    "total_jobs": totalJobs,
    "page": page,
  };
}
class Job {
  int? jobId;
  String? title;
  String? company;
  String? location;
  String? jobType;
  dynamic minExperience;
  dynamic maxExperience;
  dynamic salaryMin;
  dynamic salaryMax;
  DateTime? postedDate;

  Job({
    this.jobId,
    this.title,
    this.company,
    this.location,
    this.jobType,
    this.minExperience,
    this.maxExperience,
    this.salaryMin,
    this.salaryMax,
    this.postedDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    jobId: json["job_id"] as int?,
    title: json["title"] as String?,
    company: json["company"] as String?,
    location: json["location"] as String?,
    jobType: json["job_type"] as String?,
    minExperience: json["min_experience"],
    maxExperience: json["max_experience"],
    salaryMin: json["salary_min"],
    salaryMax: json["salary_max"],
    postedDate: json["posted_date"] != null ? DateTime.parse(json["posted_date"] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    "job_id": jobId,
    "title": title,
    "company": company,
    "location": location,
    "job_type": jobType,
    "min_experience": minExperience,
    "max_experience": maxExperience,
    "salary_min": salaryMin,
    "salary_max": salaryMax,
    "posted_date": postedDate != null
        ? "${postedDate!.year.toString().padLeft(4, '0')}-${postedDate!.month.toString().padLeft(2, '0')}-${postedDate!.day.toString().padLeft(2, '0')}"
        : null,
  };
}