// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String token;
    int userId;
    int expiresIn;
    String? role;

    LoginResponse({
        required this.token,
        required this.userId,
        required this.expiresIn,
         this.role,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        userId: json["user_id"],
        expiresIn: json["expires_in"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "expires_in": expiresIn,
        "role": role,
    };
}
