// To parse this JSON data, do
//
//     final myJobModel = myJobModelFromJson(jsonString);

import 'dart:convert';

MyJobModel myJobModelFromJson(String str) => MyJobModel.fromJson(json.decode(str));

String myJobModelToJson(MyJobModel data) => json.encode(data.toJson());

class MyJobModel {
  List<Application> applications;

  MyJobModel({
    required this.applications,
  });

  factory MyJobModel.fromJson(Map<String, dynamic> json) => MyJobModel(
    applications: List<Application>.from(json["applications"].map((x) => Application.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "applications": List<dynamic>.from(applications.map((x) => x.toJson())),
  };
}

class Application {
  int applicationId;
  int jobId;
  String jobTitle;
  String company;
  String status;
  DateTime appliedDate;

  Application({
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedDate,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    applicationId: json["application_id"],
    jobId: json["job_id"],
    jobTitle: json["job_title"],
    company: json["company"],
    status: json["status"],
    appliedDate: DateTime.parse(json["applied_date"]),
  );

  Map<String, dynamic> toJson() => {
    "application_id": applicationId,
    "job_id": jobId,
    "job_title": jobTitle,
    "company": company,
    "status": status,
    "applied_date": "${appliedDate.year.toString().padLeft(4, '0')}-${appliedDate.month.toString().padLeft(2, '0')}-${appliedDate.day.toString().padLeft(2, '0')}",
  };
}
