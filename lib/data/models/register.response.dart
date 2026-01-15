

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
    bool status;
    String message;
    Data data;

    RegisterResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String token;
    String userId;
    String userName;
    String email;

    Data({
        required this.token,
        required this.userId,
        required this.userName,
        required this.email,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userId: json["user_id"],
        userName: json["user_name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "user_name": userName,
        "email": email,
    };
}
