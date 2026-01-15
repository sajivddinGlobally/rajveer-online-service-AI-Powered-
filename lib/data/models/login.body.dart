// To parse this JSON data, do
//
//     final loginBody = loginBodyFromJson(jsonString);

import 'dart:convert';

LoginBody loginBodyFromJson(String str) => LoginBody.fromJson(json.decode(str));

String loginBodyToJson(LoginBody data) => json.encode(data.toJson());

class LoginBody {
    String email_or_phone;
    String password;

    LoginBody({
        required this.email_or_phone,
        required this.password,

    });

    factory LoginBody.fromJson(Map<String, dynamic> json) => LoginBody(
        email_or_phone: json["email_or_phone"],
        password: json["password"],

    );

    Map<String, dynamic> toJson() => {
        "email_or_phone": email_or_phone,
        "password": password,

    };
}
