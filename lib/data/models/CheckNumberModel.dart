// To parse this JSON data, do
//
//     final CheckBodyModel = CheckBodyModelFromJson(jsonString);

import 'dart:convert';

CheckBodyModel CheckBodyModelFromJson(String str) => CheckBodyModel.fromJson(json.decode(str));

String CheckBodyModelToJson(CheckBodyModel data) => json.encode(data.toJson());

class CheckBodyModel {
  String phone;


  CheckBodyModel({
    required this.phone
  });

  factory CheckBodyModel.fromJson(Map<String, dynamic> json) => CheckBodyModel(
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };
}





CheckBodyResiaterModel CheckBodyResiaterModelFromJson(String str) => CheckBodyResiaterModel.fromJson(json.decode(str));

String CheckBodyResiaterModelToJson(CheckBodyModel data) => json.encode(data.toJson());

class CheckBodyResiaterModel {
  String email;
  String phone;


  CheckBodyResiaterModel({

    required this.email,
    required this.phone
  });

  factory CheckBodyResiaterModel.fromJson(Map<String, dynamic> json) => CheckBodyResiaterModel(
    email: json["email"],
    phone: json["phone"],

  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "phone": phone,

  };
}
