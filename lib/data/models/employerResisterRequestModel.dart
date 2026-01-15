import 'dart:convert';

EmployerRegisterRequestBody employerRegisterRequestBodyFromJson(String str) =>
    EmployerRegisterRequestBody.fromJson(json.decode(str));

String employerRegisterRequestBodyToJson(EmployerRegisterRequestBody data) =>
    json.encode(data.toJson());

class EmployerRegisterRequestBody {
  String contactPerson;
  String password;
  String email;
  String companyName;
  String phone;

  EmployerRegisterRequestBody({
    required this.contactPerson,
    required this.password,
    required this.email,
    required this.companyName,
    required this.phone,
  });

  factory EmployerRegisterRequestBody.fromJson(Map<String, dynamic> json) =>
      EmployerRegisterRequestBody(
        contactPerson: json["contact_person"],
        password: json["password"],
        email: json["email"],
        companyName: json["company_name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
    "contact_person": contactPerson,
    "password": password,
    "email": email,
    "company_name": companyName,
    "phone": phone,
  };
}
