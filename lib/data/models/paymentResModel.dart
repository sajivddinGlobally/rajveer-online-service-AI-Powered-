// To parse this JSON data, do
//
//     final paymentResModel = paymentResModelFromJson(jsonString);

import 'dart:convert';

PaymentResModel paymentResModelFromJson(String str) => PaymentResModel.fromJson(json.decode(str));

String paymentResModelToJson(PaymentResModel data) => json.encode(data.toJson());

class PaymentResModel {
    String? message;
    String? transactionId;

    PaymentResModel({
        this.message,
        this.transactionId,
    });

    factory PaymentResModel.fromJson(Map<String, dynamic> json) => PaymentResModel(
        message: json["message"],
        transactionId: json["transaction_id"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "transaction_id": transactionId,
    };
}


// To parse this JSON data, do
//
//     final paymentBodyModel = paymentBodyModelFromJson(jsonString);



PaymentBodyModel paymentBodyModelFromJson(String str) => PaymentBodyModel.fromJson(json.decode(str));

String paymentBodyModelToJson(PaymentBodyModel data) => json.encode(data.toJson());

class PaymentBodyModel {
    String? amount;
    String? transactionId;
    String? image;

    PaymentBodyModel({
        this.amount,
        this.transactionId,
        this.image,
    });

    factory PaymentBodyModel.fromJson(Map<String, dynamic> json) => PaymentBodyModel(
        amount: json["amount"],
        transactionId: json["transaction_id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "transaction_id": transactionId,
        "image": image,
    };
}
