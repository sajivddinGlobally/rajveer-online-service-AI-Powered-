// To parse this JSON data, do
//
//     final jobsProfileGetModel = jobsProfileGetModelFromJson(jsonString);

import 'dart:convert';

JobsProfileGetModel jobsProfileGetModelFromJson(String str) => JobsProfileGetModel.fromJson(json.decode(str));

String jobsProfileGetModelToJson(JobsProfileGetModel data) => json.encode(data.toJson());

class JobsProfileGetModel {
  String? status;
  User? user;

  JobsProfileGetModel({
    this.status,
    this.user,
  });

  factory JobsProfileGetModel.fromJson(Map<String, dynamic> json) => JobsProfileGetModel(
    status: json["status"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? resume;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.resume,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    resume: json["resume"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "resume": resume,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
