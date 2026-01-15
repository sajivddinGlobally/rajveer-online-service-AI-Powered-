
import 'dart:convert';

PaymentCreateModel PaymentCreateModelFromJson(String str) =>
    PaymentCreateModel.fromJson(json.decode(str));

String PaymentCreateModelToJson(PaymentCreateModel data) =>
    json.encode(data.toJson());

class PaymentCreateModel {
  String plan_name;
  String currency;
  String description;


  PaymentCreateModel({

    required this.plan_name,
    required this.currency,
    required this.description,


  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) =>
      PaymentCreateModel(
        plan_name: json["plan_name"],
        currency: json["currency"],
        description: json["description"],

      );

  Map<String, dynamic> toJson() => {
    "plan_name": plan_name,
    "currency": currency,
    "description": description,

  };
}



