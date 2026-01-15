// To parse this JSON data, do
//
//     final favouriteListResModel = favouriteListResModelFromJson(jsonString);

import 'dart:convert';

FavouriteListResModel favouriteListResModelFromJson(String str) => FavouriteListResModel.fromJson(json.decode(str));

String favouriteListResModelToJson(FavouriteListResModel data) => json.encode(data.toJson());

class FavouriteListResModel {
    bool success;
    int count;
    List<Datum> data;

    FavouriteListResModel({
        required this.success,
        required this.count,
        required this.data,
    });

    factory FavouriteListResModel.fromJson(Map<String, dynamic> json) => FavouriteListResModel(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String userId;
    String favoriteUserId;
    DateTime createdAt;
    DateTime updatedAt;
    FavoriteUser favoriteUser;

    Datum({
        required this.id,
        required this.userId,
        required this.favoriteUserId,
        required this.createdAt,
        required this.updatedAt,
        required this.favoriteUser,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        favoriteUserId: json["favorite_user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        favoriteUser: FavoriteUser.fromJson(json["favorite_user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "favorite_user_id": favoriteUserId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "favorite_user": favoriteUser.toJson(),
    };
}

class FavoriteUser {
    int id;
    String name;
    String email;
    String gender;
    String age;
    String city;
    String state;
    String country;
    String photos;

    FavoriteUser({
        required this.id,
        required this.name,
        required this.email,
        required this.gender,
        required this.age,
        required this.city,
        required this.state,
        required this.country,
        required this.photos,
    });

    factory FavoriteUser.fromJson(Map<String, dynamic> json) => FavoriteUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        age: json["age"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        photos: json["photos"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "gender": gender,
        "age": age,
        "city": city,
        "state": state,
        "country": country,
        "photos": photos,
    };
}
