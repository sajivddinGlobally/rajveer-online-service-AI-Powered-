// To parse this JSON data, do
//
//     final toggleFavouriteBodyModel = toggleFavouriteBodyModelFromJson(jsonString);

import 'dart:convert';

ToggleFavouriteBodyModel toggleFavouriteBodyModelFromJson(String str) => ToggleFavouriteBodyModel.fromJson(json.decode(str));

String toggleFavouriteBodyModelToJson(ToggleFavouriteBodyModel data) => json.encode(data.toJson());

class ToggleFavouriteBodyModel {
    int userId;
    String favoriteUserId;

    ToggleFavouriteBodyModel({
        required this.userId,
        required this.favoriteUserId,
    });

    factory ToggleFavouriteBodyModel.fromJson(Map<String, dynamic> json) => ToggleFavouriteBodyModel(
        userId: json["user_id"],
        favoriteUserId: json["favorite_user_id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "favorite_user_id": favoriteUserId,
    };
}
