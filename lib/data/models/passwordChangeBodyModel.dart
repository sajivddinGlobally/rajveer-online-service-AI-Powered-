
import 'dart:convert';

PasswordChangeBodyModel passwordChangeBodyModelFromJson(String str) =>
    PasswordChangeBodyModel.fromJson(json.decode(str));

String passwordChangeBodyModelToJson(PasswordChangeBodyModel data) =>
    json.encode(data.toJson());

class PasswordChangeBodyModel {
  String email;
  String password;
  String passwordConfirmation;

  PasswordChangeBodyModel({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory PasswordChangeBodyModel.fromJson(Map<String, dynamic> json) =>
      PasswordChangeBodyModel(
        email: json["email"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}

// To parse this JSON data, do
//
//     final passwordChangeResModel = passwordChangeResModelFromJson(jsonString);

PasswordChangeResModel passwordChangeResModelFromJson(String str) =>
    PasswordChangeResModel.fromJson(json.decode(str));

String passwordChangeResModelToJson(PasswordChangeResModel data) =>
    json.encode(data.toJson());

class PasswordChangeResModel {
  String message;

  PasswordChangeResModel({required this.message});

  factory PasswordChangeResModel.fromJson(Map<String, dynamic> json) =>
      PasswordChangeResModel(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
