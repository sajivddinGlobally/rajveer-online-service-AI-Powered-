// To parse this JSON data, do
//
//     final favouriteListBodyModel = favouriteListBodyModelFromJson(jsonString);

import 'dart:convert';

FavouriteListBodyModel favouriteListBodyModelFromJson(String str) => FavouriteListBodyModel.fromJson(json.decode(str));

String favouriteListBodyModelToJson(FavouriteListBodyModel data) => json.encode(data.toJson());

class FavouriteListBodyModel {
    int userId;

    FavouriteListBodyModel({
        required this.userId,
    });

    factory FavouriteListBodyModel.fromJson(Map<String, dynamic> json) => FavouriteListBodyModel(
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
    };
}
