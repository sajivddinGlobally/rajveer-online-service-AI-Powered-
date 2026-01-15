import 'dart:convert';

UpdatePropertyModel UpdatePropertyModelFromJson(String str) =>
    UpdatePropertyModel.fromJson(json.decode(str));

String UpdatePropertyModelToJson(UpdatePropertyModel data) =>
    json.encode(data.toJson());

class UpdatePropertyModel {
  int? userId;
  int? property_id;
  String? title;
  String? description;
  int? price;
  int? area;
  int? bedrooms;
  int? bathrooms;
  UpdatePropertyModel({
    this.title,
    this.description,
    this.price,
    this.area,
    this.bedrooms,
    this.bathrooms,
    this.userId,
    this.property_id,

  });

  factory UpdatePropertyModel.fromJson(Map<String, dynamic> json) =>
      UpdatePropertyModel(
        title: json["title"],
        description: json["description"],
        price: json["price"],
        area: json["area"],
        bedrooms: json["bedrooms"],
        bathrooms: json["bathrooms"],
        userId: json["user_id"],
        property_id: json["property_id"],

      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "price": price,
    "area": area,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "user_id": userId,
    "property_id": property_id,

  };
}
