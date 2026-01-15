import 'dart:convert';

PropertyRequest propertyRequestFromJson(String str) =>
    PropertyRequest.fromJson(json.decode(str));

String propertyRequestToJson(PropertyRequest data) =>
    json.encode(data.toJson());

class PropertyRequest {
  int? userId;
  String? title;
  String? description;
  String? propertyType;
  String? category;
  int? price;
  String? location;
  int? bedrooms;
  int? bathrooms;
  int? area;
  List<String>? amenities;
  String? agentName;
  String? mobileNumber;
  String? email;
  String? localArea;
  dynamic bhk;
  String? furnishSuch;
  String? completeAddress;

  PropertyRequest({
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
    this.userId,
    this.agentName,
    this.mobileNumber,
    this.email,
    this.localArea,
    this.bhk,
    this.furnishSuch,
    this.completeAddress,
  });

  factory PropertyRequest.fromJson(Map<String, dynamic> json) =>
      PropertyRequest(
        title: json["title"],
        description: json["description"],
        propertyType: json["property_type"],
        category: json["category"],
        price: json["price"],
        location: json["location"],
        bedrooms: json["bedrooms"],
        bathrooms: json["bathrooms"],
        area: json["area"],
        amenities: json["amenities"] != null
            ? List<String>.from(json["amenities"])
            : [],
        userId: json["user_id"],
        agentName: json["agent_name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        localArea: json["local_area"],
        bhk: json["bhk"],
        furnishSuch: json["furnish_such"],
        completeAddress: json["complete_address"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "property_type": propertyType,
    "category": category,
    "price": price,
    "location": location,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "area": area,
    "amenities": amenities ?? [],
    "user_id": userId,
    "agent_name": agentName,
    "mobile_number": mobileNumber,
    "email": email,
    "local_area": localArea,
    "bhk": bhk,
    "furnish_such": furnishSuch,
    "complete_address": completeAddress,
  };
}
