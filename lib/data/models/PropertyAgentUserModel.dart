// To parse this JSON data, do
//
//     final propertyAgentUserModel = propertyAgentUserModelFromJson(jsonString);

import 'dart:convert';

PropertyAgentUserModel propertyAgentUserModelFromJson(String str) => PropertyAgentUserModel.fromJson(json.decode(str));

String propertyAgentUserModelToJson(PropertyAgentUserModel data) => json.encode(data.toJson());

class PropertyAgentUserModel {
  String? status;
  List<Booking>? bookings;

  PropertyAgentUserModel({
    this.status,
    this.bookings,
  });

  factory PropertyAgentUserModel.fromJson(Map<String, dynamic> json) => PropertyAgentUserModel(
    status: json["status"],
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  int? id;
  String? userId;
  String? propertyId;
  DateTime? bookingDate;
  String? bookingTime;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Property? property;

  Booking({
    this.id,
    this.userId,
    this.propertyId,
    this.bookingDate,
    this.bookingTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.property,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    userId: json["user_id"],
    propertyId: json["property_id"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    bookingTime: json["booking_time"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "property_id": propertyId,
    "booking_date": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "booking_time": bookingTime,
    "status": status,
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
