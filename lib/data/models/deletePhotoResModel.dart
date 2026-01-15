// To parse this JSON data, do
//
//     final deletePhotoResModel = deletePhotoResModelFromJson(jsonString);

import 'dart:convert';

DeletePhotoResModel deletePhotoResModelFromJson(String str) => DeletePhotoResModel.fromJson(json.decode(str));

String deletePhotoResModelToJson(DeletePhotoResModel data) => json.encode(data.toJson());

class DeletePhotoResModel {
    bool status;
    String message;
    List<String> deletedPhotos;
    List<String> remainingPhotos;

    DeletePhotoResModel({
        required this.status,
        required this.message,
        required this.deletedPhotos,
        required this.remainingPhotos,
    });

    factory DeletePhotoResModel.fromJson(Map<String, dynamic> json) => DeletePhotoResModel(
        status: json["status"],
        message: json["message"],
        deletedPhotos: List<String>.from(json["deleted_photos"].map((x) => x)),
        remainingPhotos: List<String>.from(json["remaining_photos"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "deleted_photos": List<dynamic>.from(deletedPhotos.map((x) => x)),
        "remaining_photos": List<dynamic>.from(remainingPhotos.map((x) => x)),
    };
}
