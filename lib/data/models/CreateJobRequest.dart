import 'dart:convert';

CreateJobRequestBody createJobRequestBodyFromJson(String str) =>
    CreateJobRequestBody.fromJson(json.decode(str));

String createJobRequestBodyToJson(CreateJobRequestBody data) =>
    json.encode(data.toJson());

class CreateJobRequestBody {
  String title;
  String description;
  List<String> requirements;
  String location;
  String minExperience;
  String maxExperience;
  String salaryMin;
  String salaryMax;
  String applicationDeadline;
  String employmentType;
  String jobType;
  dynamic employerId;

  CreateJobRequestBody({
    required this.title,
    required this.description,
    required this.requirements,
    required this.location,
    required this.minExperience,
    required this.maxExperience,
    required this.salaryMin,
    required this.salaryMax,
    required this.applicationDeadline,
    required this.employmentType,
    required this.jobType,
    required this.employerId,
  });

  factory CreateJobRequestBody.fromJson(Map<String, dynamic> json) =>
      CreateJobRequestBody(
        title: json["title"],
        description: json["description"],
        requirements: List<String>.from(json["requirements"]),
        location: json["location"],
        minExperience: json["min_experience"],
        maxExperience: json["max_experience"],
        salaryMin: json["salary_min"],
        salaryMax: json["salary_max"],
        applicationDeadline: json["application_deadline"],
        employmentType: json["employment_type"],
        jobType: json["job_type"],
        employerId: json["employer_id"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "requirements": requirements,
    "location": location,
    "min_experience": minExperience,
    "max_experience": maxExperience,
    "salary_min": salaryMin,
    "salary_max": salaryMax,
    "application_deadline": applicationDeadline,
    "employment_type": employmentType,
    "job_type": jobType,
    "employer_id": employerId,
  };
}
