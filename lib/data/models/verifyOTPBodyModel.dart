// To parse this JSON data, do
//
//     final verifyOtpBodyModel = verifyOtpBodyModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpBodyModel verifyOtpBodyModelFromJson(String str) =>
    VerifyOtpBodyModel.fromJson(json.decode(str));

String verifyOtpBodyModelToJson(VerifyOtpBodyModel data) =>
    json.encode(data.toJson());

class VerifyOtpBodyModel {
  String email;
  String otp;

  VerifyOtpBodyModel({required this.email, required this.otp});

  factory VerifyOtpBodyModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpBodyModel(email: json["email"], otp: json["otp"]);

  Map<String, dynamic> toJson() => {"email": email, "otp": otp};
}

// To parse this JSON data, do
//
//     final verifyOtpResModel = verifyOtpResModelFromJson(jsonString);

VerifyOtpResModel verifyOtpResModelFromJson(String str) =>
    VerifyOtpResModel.fromJson(json.decode(str));

String verifyOtpResModelToJson(VerifyOtpResModel data) =>
    json.encode(data.toJson());

class VerifyOtpResModel {
  String message;

  VerifyOtpResModel({required this.message});

  factory VerifyOtpResModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResModel(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
