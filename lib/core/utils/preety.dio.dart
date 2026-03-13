import 'dart:developer';
import 'package:ai_powered_app/screen/start.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'globalroute.key.dart';

Dio createDio() {
  final dio = Dio();

  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  var box = Hive.box("userdata");
  var token = box.get("token");

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.addAll({
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          //'Authorization': 'Bearer $token',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.requestOptions.path.contains("/api/login")) {
          /// ye line sirf login agar wrong ho to sirf invalid emal or password message show karega
          log("Invalid email or passworld");
          handler.next(e);
          return;
        }

        if (e.response?.statusCode == 401) {
          log(e.response.toString());
          navigatorKey.currentState?.pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => StartPage()),
            (_) => false,
          );
          log('Validation Error: ${e.response?.data}');
          String errorMessage = "Please enter valid data";

          if (e.response?.data is Map<String, dynamic>) {
            errorMessage = e.response?.data['message'];
          }
          Fluttertoast.showToast(
            msg: errorMessage,
            gravity: ToastGravity.BOTTOM,
            toastLength:
                Toast.LENGTH_LONG, // Changed to LONG for better readability
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          navigatorKey.currentState?.pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => StartPage()),
            (_) => false,
          );
          return handler.next(e);
        } else if (e.response?.statusCode == 422) {
          log('Validation Error: ${e.response?.data}');

          String errorMessage = "Please enter valid data";

          if (e.response?.data is Map<String, dynamic>) {
            final errors = e.response?.data as Map<String, dynamic>;

            // get first error message
            if (errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                errorMessage = firstError.first.toString();
              }
            }
          }
          Fluttertoast.showToast(
            msg: errorMessage,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return handler.next(e);
        } else if (e.response?.statusCode == 404) {
          // Log the full error response for debugging
          log('Validation Error: ${e.response?.data}');
          // Extract validation messages if available
          String errorMessage = "Date Not Found";
          if (e.response?.data is Map<String, dynamic>) {
            errorMessage = e.response?.data['message'];
          }

          Fluttertoast.showToast(
            msg: errorMessage,
            gravity: ToastGravity.BOTTOM,
            toastLength:
                Toast.LENGTH_LONG, // Changed to LONG for better readability
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return handler.next(e);
        } else if (e.response?.statusCode == 403) {
          // Log the full error response for debugging
          log('Validation Error: ${e.response?.data}');

          // Extract validation messages if available
          String errorMessage = "Date Not Found";
          if (e.response?.data is Map<String, dynamic>) {
            errorMessage = e.response?.data['message'];
          }

          // Show user-friendly error message
          Fluttertoast.showToast(
            msg: errorMessage,
            gravity: ToastGravity.BOTTOM,
            toastLength:
                Toast.LENGTH_LONG, // Changed to LONG for better readability
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return handler.next(e);
        } else if (e.response?.statusCode == 400) {
          // Log the full error response for debugging
          log('Validation Error: ${e.response?.data}');

          // Extract validation messages if available
          String errorMessage = "Date Not Found";
          if (e.response?.data is Map<String, dynamic>) {
            errorMessage = e.response?.data['message'];
          }

          // Show user-friendly error message
          // Fluttertoast.showToast(
          //   msg: errorMessage,
          //   gravity: ToastGravity.BOTTOM,
          //   toastLength: Toast.LENGTH_LONG,  // Changed to LONG for better readability
          //   backgroundColor: Colors.red,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );

          return handler.next(e);
        }
      },
    ),
  );

  return dio;
}

Dio createDio2() {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  return dio;
}
