// To parse this JSON data, do
//
//     final logoutresponse = logoutresponseFromJson(jsonString);

import 'dart:convert';

Logoutresponse logoutresponseFromJson(String str) => Logoutresponse.fromJson(json.decode(str));

String logoutresponseToJson(Logoutresponse data) => json.encode(data.toJson());

class Logoutresponse {
    bool status;
    String message;

    Logoutresponse({
        required this.status,
        required this.message,
    });

    factory Logoutresponse.fromJson(Map<String, dynamic> json) => Logoutresponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
