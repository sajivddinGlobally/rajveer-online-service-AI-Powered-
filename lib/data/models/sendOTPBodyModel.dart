// To parse this JSON data, do
//
//     final sendOtpBodyModel = sendOtpBodyModelFromJson(jsonString);

import 'dart:convert';

SendOtpBodyModel sendOtpBodyModelFromJson(String str) =>
    SendOtpBodyModel.fromJson(json.decode(str));

String sendOtpBodyModelToJson(SendOtpBodyModel data) =>
    json.encode(data.toJson());

class SendOtpBodyModel {
  String email;

  SendOtpBodyModel({required this.email});

  factory SendOtpBodyModel.fromJson(Map<String, dynamic> json) =>
      SendOtpBodyModel(email: json["email"]);

  Map<String, dynamic> toJson() => {"email": email};
}

// To parse this JSON data, do
//
//     final sendOtpResModel = sendOtpResModelFromJson(jsonString);

SendOtpResModel sendOtpResModelFromJson(String str) =>
    SendOtpResModel.fromJson(json.decode(str));

String sendOtpResModelToJson(SendOtpResModel data) =>
    json.encode(data.toJson());

class SendOtpResModel {
  String message;

  SendOtpResModel({required this.message});

  factory SendOtpResModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResModel(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
