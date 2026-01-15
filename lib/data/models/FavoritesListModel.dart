// To parse this JSON data, do
//
//     final FavoritesListModel = FavoritesListModelFromJson(jsonString);

import 'dart:convert';

FavoritesListModel FavoritesListModelFromJson(String str) => FavoritesListModel.fromJson(json.decode(str));

String FavoritesListModelToJson(FavoritesListModel data) => json.encode(data.toJson());

class FavoritesListModel {
  String? status;
  List<Favorite>? favorites;

  FavoritesListModel({
    this.status,
    this.favorites,
  });

  factory FavoritesListModel.fromJson(Map<String, dynamic> json) => FavoritesListModel(
    status: json["status"],
    favorites: json["favorites"] == null ? [] : List<Favorite>.from(json["favorites"]!.map((x) => Favorite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "favorites": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x.toJson())),
  };
}

class Favorite {
  String? propertyId;
  String? title;
  String? location;
  int? price;
  String? mainImageUrl;

  Favorite({
    this.propertyId,
    this.title,
    this.location,
    this.price,
    this.mainImageUrl,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    propertyId: json["property_id"],
    title: json["title"],
    location: json["location"],
    price: json["price"],
    mainImageUrl: json["main_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "title": title,
    "location": location,
    "price": price,
    "main_image_url": mainImageUrl,
  };
}
