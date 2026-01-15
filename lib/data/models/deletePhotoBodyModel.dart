// To parse this JSON data, do
//
//     final deletePhotoBodyModel = deletePhotoBodyModelFromJson(jsonString);

import 'dart:convert';

DeletePhotoBodyModel deletePhotoBodyModelFromJson(String str) => DeletePhotoBodyModel.fromJson(json.decode(str));

String deletePhotoBodyModelToJson(DeletePhotoBodyModel data) => json.encode(data.toJson());

class DeletePhotoBodyModel {
    List<String> photos;

    DeletePhotoBodyModel({
        required this.photos,
    });

    factory DeletePhotoBodyModel.fromJson(Map<String, dynamic> json) => DeletePhotoBodyModel(
        photos: List<String>.from(json["photos"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x)),
    };
}
