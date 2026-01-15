// To parse this JSON data, do
//
//     final LoginBodyModel = LoginBodyModelFromJson(jsonString);

import 'dart:convert';
LoginBodyModel LoginBodyModelFromJson(String str) => LoginBodyModel.fromJson(json.decode(str));

String LoginBodyModelToJson(LoginBodyModel data) => json.encode(data.toJson());

class LoginBodyModel {
  String idToken;
  LoginBodyModel({
    required this.idToken,
  });
  factory LoginBodyModel.fromJson(Map<String, dynamic> json) => LoginBodyModel(
    idToken: json["idToken"],
  );
  Map<String, dynamic> toJson() => {
    "idToken": idToken,
  };
}
