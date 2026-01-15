import 'dart:convert';

MatchProfileModel matchProfileModelFromJson(String str) => MatchProfileModel.fromJson(json.decode(str));

String matchProfileModelToJson(MatchProfileModel data) => json.encode(data.toJson());

class MatchProfileModel {
  bool? status; // Made nullable
  List<Match>? matches; // Made nullable

  MatchProfileModel({
    this.status,
    this.matches,
  });

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) => MatchProfileModel(
    status: json["status"],
    matches: json["matches"] != null
        ? List<Match>.from(json["matches"].map((x) => Match.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "matches": matches != null
        ? List<dynamic>.from(matches!.map((x) => x.toJson()))
        : null,
  };
}

class Match {
  int? userId; // Made nullable
  String? name; // Made nullable
  dynamic age; // Already dynamic, can handle null
  String? location; // Already nullable
  String? photoThumbnail; // Already nullable
  String? status; // Made nullable

  Match({
    this.userId,
    this.name,
    this.age,
    this.location,
    this.photoThumbnail,
    this.status,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    userId: json["user_id"],
    name: json["name"],
    age: json["age"],
    location: json["location"],
    photoThumbnail: json["photo_thumbnail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "age": age,
    "location": location,
    "photo_thumbnail": photoThumbnail,
    "status": status,
  };
}