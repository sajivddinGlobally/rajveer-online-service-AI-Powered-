/*
// To parse this JSON data, do
//
//     final recentPropertyModel = recentPropertyModelFromJson(jsonString);

import 'dart:convert';

RecentPropertyModel recentPropertyModelFromJson(String str) => RecentPropertyModel.fromJson(json.decode(str));

String recentPropertyModelToJson(RecentPropertyModel data) => json.encode(data.toJson());

class RecentPropertyModel {
  String? status;
  int? count;
  List<Property>? properties;

  RecentPropertyModel({
    this.status,
    this.count,
    this.properties,
  });

  factory RecentPropertyModel.fromJson(Map<String, dynamic> json) => RecentPropertyModel(
    status: json["status"],
    count: json["count"],
    properties: json["properties"] == null ? [] : List<Property>.from(json["properties"]!.map((x) => Property.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
  };
}

class Property {
  int? id;
  String? title;
  String? description;
  String? propertyType;
  String? category;
  String? price;
  String? location;
  int? bedrooms;
  int? bathrooms;
  String? area;
  List<String>? amenities;
  int? listedBy;
  DateTime? listedDate;
  String? agentName;
  String? mobileNumber;
  String? email;
  String? localArea;
  String? completeAddress;
  String? bhk;
  String? furnishSuch;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? is_favorite;

  Property({
    this.id,
    this.title,
    this.description,
    this.propertyType,
    this.category,
    this.price,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.amenities,
    this.listedBy,
    this.listedDate,
    this.agentName,
    this.mobileNumber,
    this.email,
    this.localArea,
    this.completeAddress,
    this.bhk,
    this.furnishSuch,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.is_favorite,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    propertyType: json["property_type"],
    category: json["category"],
    price: json["price"],
    location: json["location"],
    bedrooms: json["bedrooms"],
    bathrooms: json["bathrooms"],
    area: json["area"],
    amenities: json["amenities"] == null ? [] : List<String>.from(json["amenities"]!.map((x) => x)),
    listedBy: json["listed_by"],
    listedDate: json["listed_date"] == null ? null : DateTime.parse(json["listed_date"]),
    agentName: json["agent_name"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    localArea: json["local_area"],
    completeAddress: json["complete_address"],
    bhk: json["bhk"],
    furnishSuch: json["furnish_such"],
    photo: json["photo"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    is_favorite: json["is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "property_type": propertyType,
    "category": category,
    "price": price,
    "location": location,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "area": area,
    "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x)),
    "listed_by": listedBy,
    "listed_date": listedDate?.toIso8601String(),
    "agent_name": agentName,
    "mobile_number": mobileNumber,
    "email": email,
    "local_area": localArea,
    "complete_address": completeAddress,
    "bhk": bhk,
    "furnish_such": furnishSuch,
    "photo": photo,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_favorite": is_favorite,
  };
}
*/


// To parse this JSON data, do
//
//     final recentPropertyModel = recentPropertyModelFromJson(jsonString);

import 'dart:convert';

RecentPropertyModel recentPropertyModelFromJson(String str) => RecentPropertyModel.fromJson(json.decode(str));

String recentPropertyModelToJson(RecentPropertyModel data) => json.encode(data.toJson());

class RecentPropertyModel {
  String? status;
  int? count;
  List<Property>? properties;

  RecentPropertyModel({
    this.status,
    this.count,
    this.properties,
  });

  factory RecentPropertyModel.fromJson(Map<String, dynamic> json) => RecentPropertyModel(
    status: json["status"],
    count: json["count"],
    properties: json["properties"] == null ? [] : List<Property>.from(json["properties"]!.map((x) => Property.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
  };
}

class Property {
  int? id;
  String? title;
  String? description;
  String? propertyType;
  String? category;
  String? price;
  String? location;
  String? bedrooms;
  String? bathrooms;
  String? area;
  dynamic amenities;
  String? listedBy;
  DateTime? listedDate;
  String? agentName;
  String? mobileNumber;
  String? email;
  String? localArea;
  String? completeAddress;
  String? bhk;
  dynamic furnishSuch;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? is_favorite;

  Property({
    this.id,
    this.title,
    this.description,
    this.propertyType,
    this.category,
    this.price,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.amenities,
    this.listedBy,
    this.listedDate,
    this.agentName,
    this.mobileNumber,
    this.email,
    this.localArea,
    this.completeAddress,
    this.bhk,
    this.furnishSuch,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.is_favorite,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    propertyType: json["property_type"],
    category: json["category"],
    price: json["price"],
    location: json["location"],
    bedrooms: json["bedrooms"],
    bathrooms: json["bathrooms"],
    area: json["area"],
    amenities: json["amenities"],
    listedBy: json["listed_by"],
    listedDate: json["listed_date"] == null ? null : DateTime.parse(json["listed_date"]),
    agentName: json["agent_name"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    localArea: json["local_area"],
    completeAddress: json["complete_address"],
    bhk: json["bhk"],
    furnishSuch: json["furnish_such"],
    photo: json["photo"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    is_favorite: json["is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "property_type": propertyType,
    "category": category,
    "price": price,
    "location": location,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "area": area,
    "amenities": amenities,
    "listed_by": listedBy,
    "listed_date": listedDate?.toIso8601String(),
    "agent_name": agentName,
    "mobile_number": mobileNumber,
    "email": email,
    "local_area": localArea,
    "complete_address": completeAddress,
    "bhk": bhk,
    "furnish_such": furnishSuch,
    "photo": photo,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_favorite": is_favorite,
  };
}
