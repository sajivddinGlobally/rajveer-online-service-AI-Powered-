/*
// To parse this JSON data, do
//
//     final propertyDetailModel = propertyDetailModelFromJson(jsonString);

import 'dart:convert';

PropertyDetailModel propertyDetailModelFromJson(String str) => PropertyDetailModel.fromJson(json.decode(str));

String propertyDetailModelToJson(PropertyDetailModel data) => json.encode(data.toJson());

class PropertyDetailModel {
  String? status;
  Property? property;

  PropertyDetailModel({
    this.status,
    this.property,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) => PropertyDetailModel(
    status: json["status"],
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
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
  int? bedrooms;
  int? bathrooms;
  String? area;
  dynamic amenities;
  ListedBy? listedBy;
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
  List<Image>? images;

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
    this.images,
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
    listedBy: json["listed_by"] == null ? null : ListedBy.fromJson(json["listed_by"]),
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
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
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
    "listed_by": listedBy?.toJson(),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class Image {
  String? fullImageUrl;

  Image({
    this.fullImageUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    fullImageUrl: json["full_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "full_image_url": fullImageUrl,
  };
}

class ListedBy {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  ListedBy({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory ListedBy.fromJson(Map<String, dynamic> json) => ListedBy(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
*//*




// To parse this JSON data, do
//
//     final propertyDetailModel = propertyDetailModelFromJson(jsonString);

import 'dart:convert';

PropertyDetailModel propertyDetailModelFromJson(String str) => PropertyDetailModel.fromJson(json.decode(str));

String propertyDetailModelToJson(PropertyDetailModel data) => json.encode(data.toJson());

class PropertyDetailModel {
  String? status;
  Property? property;

  PropertyDetailModel({
    this.status,
    this.property,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) => PropertyDetailModel(
    status: json["status"],
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
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
  ListedBy? listedBy;
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
  List<Image>? images;

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
    this.images,
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
    listedBy: json["listed_by"] == null ? null : ListedBy.fromJson(json["listed_by"]),
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
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
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
    "listed_by": listedBy?.toJson(),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class Image {
  String? fullImageUrl;

  Image({
    this.fullImageUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    fullImageUrl: json["full_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "full_image_url": fullImageUrl,
  };
}

class ListedBy {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? seller_name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  ListedBy({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.seller_name,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory ListedBy.fromJson(Map<String, dynamic> json) => ListedBy(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    seller_name: json["seller_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
    "seller_name": seller_name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
  };
}
*/

// To parse this JSON data, do
//
//     final propertyDetailModel = propertyDetailModelFromJson(jsonString);

import 'dart:convert';

PropertyDetailModel propertyDetailModelFromJson(String str) => PropertyDetailModel.fromJson(json.decode(str));

String propertyDetailModelToJson(PropertyDetailModel data) => json.encode(data.toJson());

class PropertyDetailModel {
  String? status;
  Property? property;

  PropertyDetailModel({
    this.status,
    this.property,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) => PropertyDetailModel(
    status: json["status"],
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
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
  List<String>? amenities;
  ListedBy? listedBy;
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
  List<ImageList>? images;
  List<Booking>? bookings;

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
    this.images,
    this.bookings,
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
    listedBy: json["listed_by"] == null ? null : ListedBy.fromJson(json["listed_by"]),
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
    images: json["images"] == null ? [] : List<ImageList>.from(json["images"]!.map((x) => ImageList.fromJson(x))),
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
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
    "listed_by": listedBy?.toJson(),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
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

  Booking({
    this.id,
    this.userId,
    this.propertyId,
    this.bookingDate,
    this.bookingTime,
    this.status,
    this.createdAt,
    this.updatedAt,
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
  };
}

class ImageList {
  String? fullImageUrl;

  ImageList({
    this.fullImageUrl,
  });

  factory ImageList.fromJson(Map<String, dynamic> json) => ImageList(
    fullImageUrl: json["full_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "full_image_url": fullImageUrl,
  };
}

class ListedBy {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  dynamic sellerName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  ListedBy({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.sellerName,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory ListedBy.fromJson(Map<String, dynamic> json) => ListedBy(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    sellerName: json["seller_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
    "seller_name": sellerName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
  };
}
