import 'dart:convert';

ProfileBasedModel profileBasedModelFromJson(String str) => ProfileBasedModel.fromJson(json.decode(str));

String profileBasedModelToJson(ProfileBasedModel data) => json.encode(data.toJson());

class ProfileBasedModel {
  bool? status; // Made nullable in case API returns null
  List<Result>? results; // Made nullable
  int? totalResults; // Made nullable
  int? page; // Made nullable
  int? limit; // Made nullable

  ProfileBasedModel({
    this.status,
    this.results,
    this.totalResults,
    this.page,
    this.limit,
  });

  factory ProfileBasedModel.fromJson(Map<String, dynamic> json) => ProfileBasedModel(
    status: json["status"],
    results: json["results"] != null
        ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
        : null,
    totalResults: json["total_results"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "results": results != null
        ? List<dynamic>.from(results!.map((x) => x.toJson()))
        : null,
    "total_results": totalResults,
    "page": page,
    "limit": limit,
  };
}

class Result {
  dynamic userId; // Already dynamic, can handle null
  String? name; // Made nullable
  dynamic age; // Already dynamic, can handle null
  String? location; // Already nullable
  String? education; // Already nullable
  String? occupation; // Already nullable
  String? photoThumbnail; // Already nullable
  String? city; // Already nullable
  String? state; // Already nullable
  String? profileId; // Already nullable
  String? height; // Already nullable

  Result({
    this.userId,
    this.name,
    this.age,
    this.location,
    this.education,
    this.occupation,
    this.photoThumbnail,
    this.city,
    this.state,
    this.profileId,
    this.height
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    userId: json["user_id"],
    name: json["name"],
    age: json["age"],
    location: json["location"],
    education: json["education"],
    occupation: json["occupation"],
    photoThumbnail: json["photo_thumbnail"],
    profileId: json["profileId"],
    state: json["state"],
    city: json["city"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "age": age,
    "location": location,
    "education": education,
    "occupation": occupation,
    "photo_thumbnail": photoThumbnail,
    "profileId": profileId,
    "height": height,
    "city": city,
    "state": state,
  };
}