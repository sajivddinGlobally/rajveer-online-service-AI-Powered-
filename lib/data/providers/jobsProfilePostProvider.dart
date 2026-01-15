/*


import 'dart:io';
import 'package:ai_powered_app/screen/jobs.screen/home.screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/utils/preety.dio.dart';

class  ProfileProvider {

  static Future<void> updateProfile({
    required String email,
    required String name,
    required String phone,
    required File resumeFile,
    required BuildContext context,
  }) async {
    final dio = await createDio();
    final fileExtension = resumeFile.path
        .split('.')
        .last
        .toLowerCase();
    MediaType mediaType;
    if (fileExtension == 'pdf') {
      mediaType = MediaType("application", "pdf");
    } else if (fileExtension == 'doc') {
      mediaType = MediaType("application", "msword");
    } else if (fileExtension == 'docx') {
      mediaType = MediaType("application",
          "vnd.openxmlformats-officedocument.wordprocessingml.document");
    } else {
      Fluttertoast.showToast(
        msg: "Invalid file type. Please upload a PDF, DOC, or DOCX file.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }
    final box = await Hive.openBox('userdata');
    final userId = box.get('user_id');
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'resume': await MultipartFile.fromFile(
        resumeFile.path,
        filename: resumeFile.path
            .split('/')
            .last,
        contentType: mediaType,
      ),
    });

    final response = await dio.post(
      'https://matrimony.rajveerfacility.in/api/jobseeker/profile/update?user_id=$userId',
      data: formData,
    );

    if (response.data["status"] == "success") {
      Fluttertoast.showToast(
        msg: "Update Profile successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    } else {
      Fluttertoast.showToast(
        msg: "Update Profile failed: ${response.data['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }

}*/


import 'dart:io';
import 'package:ai_powered_app/screen/jobs.screen/home.screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/utils/preety.dio.dart';
import '../../data/providers/jobsProfileGetProvider.dart'; // Import the provider

class ProfileProvider {
  static Future<void> updateProfile({
    required String email,
    required String name,
    required String phone,
    required File resumeFile,
    required BuildContext context,
    required WidgetRef ref, // Add WidgetRef to access Riverpod providers
  }) async {
    final dio = await createDio();
    final fileExtension = resumeFile.path.split('.').last.toLowerCase();
    MediaType mediaType;
    if (fileExtension == 'pdf') {
      mediaType = MediaType("application", "pdf");
    } else if (fileExtension == 'doc') {
      mediaType = MediaType("application", "msword");
    } else if (fileExtension == 'docx') {
      mediaType = MediaType(
          "application", "vnd.openxmlformats-officedocument.wordprocessingml.document");
    } else {
      Fluttertoast.showToast(
        msg: "Invalid file type. Please upload a PDF, DOC, or DOCX file.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }
    final box = await Hive.openBox('userdata');
    final userId = box.get('user_id');
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'resume': await MultipartFile.fromFile(
        resumeFile.path,
        filename: resumeFile.path.split('/').last,
        contentType: mediaType,
      ),
    });

    final response = await dio.post(
      'https://matrimony.rajveerfacility.in/api/jobseeker/profile/update?user_id=$userId',
      data: formData,
    );

    if (response.data["status"] == "success") {
      Fluttertoast.showToast(
        msg: "Update Profile successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      // Invalidate the provider to trigger a refresh of the profile data
      ref.invalidate(jobProfileDataProvider);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Fluttertoast.showToast(
        msg: "Update Profile failed: ${response.data['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }
}