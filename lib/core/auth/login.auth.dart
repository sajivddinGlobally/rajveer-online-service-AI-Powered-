import 'dart:developer';
import 'dart:io';
import 'package:ai_powered_app/data/models/LoginBodyFirbase.dart';
import 'package:ai_powered_app/screen/jobs.screen/basic.info.screen.dart';
import 'package:ai_powered_app/screen/login.page.dart';
import 'package:ai_powered_app/screen/matrimony.screen/home.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http_parser/http_parser.dart';
import '../../data/models/CheckNumberModel.dart';
import '../../data/models/PaymentCreateModel.dart';
import '../../data/models/PaymentVerifyModel.dart';
import '../../data/models/employerResisterRequestModel.dart';
import '../../data/models/login.body.dart';
import '../../data/models/login.response.dart';
import '../../data/models/register.req.model.dart';
import '../../data/models/register.response.dart';
import '../../screen/OtpScreen.dart';
import '../../screen/jobs.screen/home.screen.dart';
import '../../screen/realEstate/realEstate.home.page.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';
import 'package:path/path.dart' as path;

class Auth {
  // Auth.dart mein
  static Future<Map<String, dynamic>> checkUserExists({
    required String endpoint, // jaise "job", "realestate", "matrimony"
    required String phone,
    required String email,
    required BuildContext context,
  }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.checkUserExists(
        endpoint: endpoint,
        body: CheckBodyResiaterModel(email: email, phone: phone),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final bool exists = data['exists'] == true;
        final String message =
            data['message'] ?? (exists ? "Already registered" : "New user");
        final String amount = data['plan']?['price'] ?? "0";

        return {"exists": exists, "amount": amount};
      }
      return {"exists": false, "amount": "0"};
    } on DioException catch (e) {
      _handleDioError(e);
      return {"exists": false, "amount": "0"};
    } catch (e) {
      print("Check exists error: $e");
      return {"exists": false, "amount": "0"};
    }
  }

  static Future<void> jobsLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.jobsLogin(
        LoginBody(email_or_phone: email, password: password),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // optional: remove old data
        await box.put('token', loginData.token);
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('type', "JOBS");
        String userName = email.split('@').first; // Gets everything before '@'
        await box.put('userName', userName);
        await box.put('expiresIn', loginData.expiresIn);
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: ${response.response.data}');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> loginFirbaseJob(
    String idToken,

    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.loginFirbaseJob(
        LoginBodyModel(idToken: idToken),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // optional: remove old data
        await box.put('token', loginData.token);
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('type', "JOBS");
        // String userName = email.split('@').first; // Gets everything before '@'
        // await box.put('userName', userName);
        await box.put('expiresIn', loginData.expiresIn);
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: ${response.response.data}');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.login(
        LoginBody(email_or_phone: email, password: password),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: Clear previous session
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('expiresIn', loginData.expiresIn);
        await box.put('type', "MATRIMONY");
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: $data');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> loginFirbase(String idToken, BuildContext context) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.loginFirbase(
        LoginBodyModel(idToken: idToken),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: Clear previous session
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('expiresIn', loginData.expiresIn);
        await box.put('type', "MATRIMONY");
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: $data');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> loginFirbaseRealState(
    String idToken,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.loginFirbaseRealState(
        LoginBodyModel(idToken: idToken),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);

        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: remove old data
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('role', loginData.role);
        await box.put('type', "REAL ESTATE");

        // Extract username from email
        // String userName = email.split('@').first;
        // await box.put('userName', userName);

        print('User ID: ${loginData.userId}');
        print('Token: ${loginData.token}');

        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );

        log('Login successful: $data');

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const RealestateHomePage()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> realStateLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.realStateLogin(
        LoginBody(email_or_phone: email, password: password),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);

        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: remove old data
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('role', loginData.role);
        await box.put('type', "REAL ESTATE");

        // Extract username from email
        String userName = email.split('@').first;
        await box.put('userName', userName);

        print('User ID: ${loginData.userId}');
        print('Token: ${loginData.token}');

        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );

        log('Login successful: $data');

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const RealestateHomePage()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      // Fluttertoast.showToast(
      //   msg: 'An unexpected error occurred: $e',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.TOP,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 12.0,
      // );
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> register(
    String email,
    String password,
    String name,
    String phone,
    String age,
    String gender,
    String date_of_birth,
    String transaction_id,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.register(
      RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
        gender: gender,
        dateOfBirth: date_of_birth,
        role: '',
        transactionId: transaction_id,
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      // Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<void> registerRealState(
    String name,
    String email,
    String password,
    String phone,
    String role,
    String seller_name,
    String tempToken,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.registerRealState(
      RegisterRequest(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        seller_name: seller_name,
        dateOfBirth: '',
        age: '',
        gender: '',
        transactionId: tempToken,
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      // Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, String>> paymentCreateApi(
    String plan_name,
    String currency,
    String description,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrder(
        PaymentCreateModel(
          plan_name: plan_name,
          currency: currency,
          description: description,
        ),
      );

      // Check if response is successful
      if (response.data['success'] == true) {
        // Your backend returns order_id inside "payment" object
        final String orderId = response.data['payment']['order_id'].toString();
        final String tempToken =
            response.data['payment']['temp_token'].toString();
        return {'orderId': orderId, 'tempToken': tempToken};
        //return orderId;
      } else {
        throw Exception(response.data['message'] ?? "Failed to create order");
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');

      throw Exception(errorMessage); // Ya phir custom PaymentException
    }
  }

  static Future<Map<String, dynamic>> paymentVerifyApi(
    String razorpay_payment_id,
    String razorpay_order_id,
    String razorpay_signature,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      // Your backend returns { success: true, payment: { ... } }
      if (response.data['success'] == true) {
        return response.data; // Return full data (contains payment info)
      } else {
        throw Exception(
          response.data['message'] ?? "Payment verification failed",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> registerJobSeeker({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String transactionId,
    required File resumeFile,

    required BuildContext context,
  }) async {
    final dio = await createDio();

    // Determine file extension and MIME type
    final fileExtension = resumeFile.path.split('.').last.toLowerCase();
    String? mimeType;

    if (fileExtension == 'pdf') {
      mimeType = 'application/pdf';
    } else {
      Fluttertoast.showToast(
        msg: "Please upload only PDF, files.",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'transaction_id': transactionId,
        'resume': await MultipartFile.fromFile(
          resumeFile.path,
          filename: path.basename(resumeFile.path),
        ),
      });
      // https://jobs.rajveerfacility.in/api/jobs/auth/register
      final response = await dio.post(
        "https://jobs.rajveerfacility.in/api/jobs/auth/register",
        // 'https://matrimony.rajveerfacility.in/api/jobs/auth/register',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Registration successful!",
          backgroundColor: Colors.green,
        );
        // Navigator.pop(context);
      }
    } on DioException catch (e) {
      String errorMsg = "Registration failed";

      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors is Map && errors.containsKey('resume')) {
          errorMsg = errors['resume'][0];
        } else if (errors is Map && errors.containsKey('email')) {
          errorMsg = errors['email'][0];
        }
      }

      Fluttertoast.showToast(msg: errorMsg, backgroundColor: Colors.red);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred",
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> registerEmployer(
    String email,
    String password,
    String name,
    String phone,
    String age,
    String gender,
    String date_of_birth,
    String tempToken,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.register(
      RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
        gender: gender,
        dateOfBirth: date_of_birth,
        role: '',
        transactionId: tempToken,
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<void> resisterEmployerRequestBody(
    String contact_person,
    String email,
    String password,
    String company_name,
    String phone,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.resisterEmployer(
      EmployerRegisterRequestBody(
        contactPerson: contact_person,
        password: password,
        email: email,
        companyName: company_name,
        phone: phone,
      ),
    );
    if (response.response.statusCode == 200 ||
        response.response.statusCode == 201) {
      final box = await Hive.openBox('userdata');
      await box.put('employer_id', response.response.data["employer_id"]);
      final employer_id = box.get('employer_id');
      print('employer_id: $employer_id');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const BasicInfoScreen()),
      );
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Login successful: ${response.response.data}');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const BasicInfoScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<void> checkNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.checkNumber(
        CheckBodyModel(phone: phoneNumber),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final bool exists = data['exists'] == true;
        final String message = data['message'] ?? "Processing...";

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: exists ? Colors.green : Colors.blue,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        if (exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Otpscreen(
                    colorTitle:
                        "MATRIMONY", // ya widget.title pass kar sakte ho
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        }
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Unexpected error", backgroundColor: Colors.red);
    }
  }

  static Future<void> checkNumberJob(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.checkNumberJob(
        CheckBodyModel(phone: phoneNumber),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final bool exists = data['exists'] == true;
        final String message = data['message'] ?? "Processing...";

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: exists ? Colors.green : Colors.blue,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        if (exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      Otpscreen(colorTitle: "JOBS", phoneNumber: phoneNumber),
            ),
          );
        }
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Unexpected error", backgroundColor: Colors.red);
    }
  }

  static Future<void> checkNumberRealState(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.checkNumberRealState(
        CheckBodyModel(phone: phoneNumber),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final bool exists = data['exists'] == true;
        final String message = data['message'] ?? "Processing...";

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: exists ? Colors.green : Colors.blue,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        if (exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Otpscreen(
                    colorTitle: "REAL ESTATE",
                    phoneNumber: phoneNumber,
                  ),
            ),
          );
        }
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Unexpected error", backgroundColor: Colors.red);
    }
  }

  static void _handleDioError(DioException e) {
    String msg = "Something went wrong";
    if (e.response?.statusCode == 403) {
      msg =
          e.response?.data['message'] ??
          'Your profile is under review. Please wait.';
      Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.orange,
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      msg = e.response?.data['message'] ?? 'Login failed. Try again.';
      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
    }
  }
}
