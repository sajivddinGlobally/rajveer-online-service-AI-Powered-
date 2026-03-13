import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String name;
  String email;
  String password;
  String dateOfBirth;
  String gender;
  String age;
  String role;
  String? seller_name;
  String phone;
  String transactionId;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.age,
    required this.role,
    this.seller_name,
    required this.gender,
    required this.phone,
    required this.transactionId,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        dateOfBirth: json["date_of_birth"],
        age: json["age"],
        role: json["role"],
        seller_name: json["seller_name"],
        gender: json["gender"],
        phone: json["phone"],
        transactionId: json['transaction_id']
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "date_of_birth": dateOfBirth,
    "age": age,
    "role": role,
    "seller_name": seller_name,
    "gender": gender,
    "phone": phone,
    "transaction_id": transactionId,
  };
}
