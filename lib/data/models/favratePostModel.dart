// To parse this JSON data, do
//
//     final SendFavrateBody = SendFavrateBodyFromJson(jsonString);

import 'dart:convert';

SendFavrateBody SendFavrateBodyFromJson(String str) =>
    SendFavrateBody.fromJson(json.decode(str));

String SendFavrateBodyToJson(SendFavrateBody data) =>
    json.encode(data.toJson());

class SendFavrateBody {
  int propertyId;
  int userId;
  String action;


  SendFavrateBody({
    required this.propertyId,
    required this.userId,
    required this.action,
  
  });

  factory SendFavrateBody.fromJson(Map<String, dynamic> json) =>
      SendFavrateBody(
        propertyId: json["property_id"],
        userId: json["user_id"],
        action: json["action"],
      
      );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "user_id": userId,
    "action": action,
  
  };
}
