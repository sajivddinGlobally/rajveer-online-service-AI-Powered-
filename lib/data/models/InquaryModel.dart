// To parse this JSON data, do
//
//     final sendInquiryBody = sendInquiryBodyFromJson(jsonString);

import 'dart:convert';

SendInquiryBody sendInquiryBodyFromJson(String str) =>
    SendInquiryBody.fromJson(json.decode(str));

String sendInquiryBodyToJson(SendInquiryBody data) =>
    json.encode(data.toJson());

class SendInquiryBody {
  int user_id;
  String message;
  int property_id;

  SendInquiryBody({
    required this.user_id,
    required this.message,
    required this.property_id,
  });

  factory SendInquiryBody.fromJson(Map<String, dynamic> json) =>
      SendInquiryBody(
        user_id: json["user_id"],
        message: json["message"],
        property_id: json["property_id"],
      );

  Map<String, dynamic> toJson() => {
    "user_id": user_id,
    "message": message,
    "property_id": property_id,
  };
}
