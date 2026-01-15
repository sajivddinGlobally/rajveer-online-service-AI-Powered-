
import 'dart:convert';

BookingDateBodyModel BookingDateBodyModelFromJson(String str) =>
    BookingDateBodyModel.fromJson(json.decode(str));

String BookingDateBodyModelToJson(BookingDateBodyModel data) =>
    json.encode(data.toJson());

class BookingDateBodyModel {
  String email;
  String password;
  String passwordConfirmation;

  BookingDateBodyModel({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory BookingDateBodyModel.fromJson(Map<String, dynamic> json) =>
      BookingDateBodyModel(
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