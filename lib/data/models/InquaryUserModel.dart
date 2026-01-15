// To parse this JSON data, do
//
//     final inquaryUserListModel = inquaryUserListModelFromJson(jsonString);

import 'dart:convert';

InquaryUserListModel inquaryUserListModelFromJson(String str) => InquaryUserListModel.fromJson(json.decode(str));

String inquaryUserListModelToJson(InquaryUserListModel data) => json.encode(data.toJson());

class InquaryUserListModel {
  String? status;
  List<Inquiry>? inquiries;

  InquaryUserListModel({
    this.status,
    this.inquiries,
  });

  factory InquaryUserListModel.fromJson(Map<String, dynamic> json) => InquaryUserListModel(
    status: json["status"],
    inquiries: json["inquiries"] == null ? [] : List<Inquiry>.from(json["inquiries"]!.map((x) => Inquiry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "inquiries": inquiries == null ? [] : List<dynamic>.from(inquiries!.map((x) => x.toJson())),
  };
}

class Inquiry {
  int? id;
  String? userId;
  String? propertyId;
  String? message;
  String? status;
  DateTime? sentDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Property? property;

  Inquiry({
    this.id,
    this.userId,
    this.propertyId,
    this.message,
    this.status,
    this.sentDate,
    this.createdAt,
    this.updatedAt,
    this.property,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) => Inquiry(
    id: json["id"],
    userId: json["user_id"],
    propertyId: json["property_id"],
    message: json["message"],
    status: json["status"],
    sentDate: json["sent_date"] == null ? null : DateTime.parse(json["sent_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "property_id": propertyId,
    "message": message,
    "status": status,
    "sent_date": sentDate?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "property": property?.toJson(),
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
  String? furnishSuch;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;

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
  };
}
