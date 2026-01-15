// To parse this JSON data, do
//
//     final toggleFavouriteResModel = toggleFavouriteResModelFromJson(jsonString);

import 'dart:convert';

ToggleFavouriteResModel toggleFavouriteResModelFromJson(String str) => ToggleFavouriteResModel.fromJson(json.decode(str));

String toggleFavouriteResModelToJson(ToggleFavouriteResModel data) => json.encode(data.toJson());

class ToggleFavouriteResModel {
    bool success;
    String message;

    ToggleFavouriteResModel({
        required this.success,
        required this.message,
    });

    factory ToggleFavouriteResModel.fromJson(Map<String, dynamic> json) => ToggleFavouriteResModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
