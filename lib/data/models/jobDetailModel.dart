import 'dart:convert';

JobDetailModel jobDetailModelFromJson(String str) => JobDetailModel.fromJson(json.decode(str));

String jobDetailModelToJson(JobDetailModel data) => json.encode(data.toJson());

class JobDetailModel {
  bool? status;
  String? message;
  Data? data;

  JobDetailModel({this.status, this.message, this.data});

  factory JobDetailModel.fromJson(Map<String, dynamic> json) => JobDetailModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? title;
  dynamic company;
  String? description;
  List<String>? requirements;  // ← AB LIST HAI
  String? location;
  dynamic salaryRange;
  String? employmentType;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? minExperience;
  String? maxExperience;
  String? salaryMin;
  String? salaryMax;
  dynamic postedDate;
  DateTime? applicationDeadline;
  dynamic employerId;
  String? category;

  Data({
    this.id,
    this.title,
    this.company,
    this.description,
    this.requirements,
    this.location,
    this.salaryRange,
    this.employmentType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.minExperience,
    this.maxExperience,
    this.salaryMin,
    this.salaryMax,
    this.postedDate,
    this.applicationDeadline,
    this.employerId,
    this.category,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // ← YEH SABSE ZAROORI HAI
    var reqRaw = json["requirements"];

    List<String> parsedReqs = [];
    if (reqRaw != null) {
      if (reqRaw is List) {
        parsedReqs = reqRaw.cast<String>();
      } else if (reqRaw is String) {
        try {
          // Fix: "[\"'item1', 'item2'\"]" → ["item1", "item2"]
          String cleaned = reqRaw
              .replaceAll("'", '"')
              .replaceAll(r'\"', '"');

          if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
            final List<dynamic> list = jsonDecode(cleaned);
            parsedReqs = list.cast<String>();
          } else {
            // Fallback: split by comma
            parsedReqs = cleaned
                .split(',')
                .map((s) => s.replaceAll('"', '').replaceAll("'", '').trim())
                .where((s) => s.isNotEmpty)
                .toList();
          }
        } catch (e) {
          parsedReqs = [reqRaw];
        }
      }
    }

    return Data(
      id: json["id"],
      title: json["title"],
      company: json["company"],
      description: json["description"],
      requirements: parsedReqs,  // ← AB HAMESHA LIST HOGA
      location: json["location"],
      salaryRange: json["salary_range"],
      employmentType: json["employment_type"],
      status: json["status"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      minExperience: json["min_experience"],
      maxExperience: json["max_experience"],
      salaryMin: json["salary_min"],
      salaryMax: json["salary_max"],
      postedDate: json["posted_date"],
      applicationDeadline: json["application_deadline"] == null
          ? null
          : DateTime.parse(json["application_deadline"]),
      employerId: json["employer_id"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "company": company,
    "description": description,
    "requirements": requirements,
    "location": location,
    "salary_range": salaryRange,
    "employment_type": employmentType,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "min_experience": minExperience,
    "max_experience": maxExperience,
    "salary_min": salaryMin,
    "salary_max": salaryMax,
    "posted_date": postedDate,
    "application_deadline": applicationDeadline?.toIso8601String(),
    "employer_id": employerId,
    "category": category,
  };
}