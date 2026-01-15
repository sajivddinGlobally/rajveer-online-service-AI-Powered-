

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../screen/realEstate/realEstate.home.page.dart';
import '../models/CreateProperyModel.dart';
import 'package:http_parser/http_parser.dart';

import '../models/UpdatePropertyModel.dart';

class CreatePropertyProvider {


  static Future<void> submitProperty({
    required PropertyRequest property,
    required BuildContext context,
    File? singleImage, // For single image (photo)
    List<File>? multipleImages, // For multiple images (images[])
  }) async {
    final dio = Dio();
    // Open Hive box and retrieve token
    final box = await Hive.openBox('userdata');
    final token = box.get('token');
    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(
        msg: "Authentication token is missing. Please log in.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
      return;
    }
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); // Add logging for debugging
    MultipartFile? singleImageMultipart;
    List<MultipartFile>? multipleImagesMultipart;
    if (singleImage != null) {
      final extension = singleImage.path.split('.').last.toLowerCase();
      MediaType? mediaType;
      if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
      } else {
        Fluttertoast.showToast(
          msg: "Invalid image type for single image. Only JPG, PNG, and WEBP are allowed.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
        return;
      }
      singleImageMultipart = await MultipartFile.fromFile(
        singleImage.path,
        filename: singleImage.path.split('/').last,
        contentType: mediaType,
      );
    }
    if (multipleImages != null && multipleImages.isNotEmpty) {
      multipleImagesMultipart = [];
      for (var imageFile in multipleImages) {
        final extension = imageFile.path.split('.').last.toLowerCase();
        MediaType? mediaType;
        if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
        } else {
          Fluttertoast.showToast(
            msg: "Invalid image type in multiple images. Only JPG, PNG, and WEBP are allowed.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12,
          );
          return;
        }
        final imageMultipart = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: mediaType,
        );
        multipleImagesMultipart.add(imageMultipart);
      }
    }

    try {
      final formData = FormData.fromMap({
        ...property.toJson(),
        if (singleImageMultipart != null) 'photo': singleImageMultipart, // Single image field
        if (multipleImagesMultipart != null) 'images[]': multipleImagesMultipart, // Multiple images field
      });
print(formData);
      final response = await dio.post(
        'https://matrimony.rajveerfacility.in/api/realestate/createProperty',
        data: formData,
      );

      if (response.statusCode == 200 ||response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Property submitted successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12,
        );
     // Navigator.push(context, MaterialPageRoute(builder: (context)=>RealestateHomePage()));
      }
      else {
        Fluttertoast.showToast(
          msg: "Submission failed: ${response.data['message'] ?? 'Unknown error'}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Error: ${e.message}";
      if (e.response != null) {
        errorMessage = "Error: ${e.response?.data['message'] ?? e.response?.statusCode}";
        print('Response Data: ${e.response?.data}'); // Log response for debugging
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unexpected error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    }
  }



/*

  static Future<void> updateProperty({
    required UpdatePropertyModel property,
    required BuildContext context,
    File? singleImage, // For single image (photo)
    List<File>? multipleImages, // For multiple images (images[])
    final int? propertyId,
  }) async {
    final dio = Dio();
    final box = await Hive.openBox('userdata');
    final token = box.get('token');

    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(
        msg: "Authentication token is missing. Please log in.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
      return;
    }
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); // Add logging for debugging
    MultipartFile? singleImageMultipart;
    List<MultipartFile>? multipleImagesMultipart;
    if (singleImage != null) {
      final extension = singleImage.path.split('.').last.toLowerCase();
      MediaType? mediaType;
      if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
      } else {
        Fluttertoast.showToast(
          msg: "Invalid image type for single image. Only JPG, PNG, and WEBP are allowed.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
        return;
      }
      singleImageMultipart = await MultipartFile.fromFile(
        singleImage.path,
        filename: singleImage.path.split('/').last,
        contentType: mediaType,
      );
    }
    if (multipleImages != null && multipleImages.isNotEmpty) {
      multipleImagesMultipart = [];
      for (var imageFile in multipleImages) {
        final extension = imageFile.path.split('.').last.toLowerCase();
        MediaType? mediaType;
        if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
        } else {
          Fluttertoast.showToast(
            msg: "Invalid image type in multiple images. Only JPG, PNG, and WEBP are allowed.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12,
          );
          return;
        }
        final imageMultipart = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: mediaType,
        );
        multipleImagesMultipart.add(imageMultipart);
      }
    }

    try {
      final formData = FormData.fromMap({
        ...property.toJson(),
        if (singleImageMultipart != null) 'photo': singleImageMultipart, // Single image field
        if (multipleImagesMultipart != null) 'images[]': multipleImagesMultipart, // Multiple images field
      });

      final response = await dio.post(
        'https://matrimony.rajveerfacility.in/api/update-properties',
        data: formData,
      );

      if (response.statusCode == 200 ||response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Property submitted successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RealestateHomePage()));
      } else {
        Fluttertoast.showToast(
          msg: "Submission failed: ${response.data['message'] ?? 'Unknown error'}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Error: ${e.message}";
      if (e.response != null) {
        errorMessage = "Error: ${e.response?.data['message'] ?? e.response?.statusCode}";
        print('Response Data: ${e.response?.data}'); // Log response for debugging
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unexpected error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    }
  }*/

/*
  static Future<void> updateProperty({
    required UpdatePropertyModel property,
    required BuildContext context,
    File? singleImage,
    List<File>? multipleImages,

  }) async {
    final dio = Dio();
    final box = await Hive.openBox('userdata');
    final token = box.get('token');

    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(
        msg: "Authentication token is missing. Please log in.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
      return;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.validateStatus = (status) => status != null && status >= 200 && status < 400;
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    MultipartFile? singleImageMultipart;
    List<MultipartFile>? multipleImagesMultipart;

    if (singleImage != null) {
      final extension = singleImage.path.split('.').last.toLowerCase();
      MediaType? mediaType;
      if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
      } else {
        Fluttertoast.showToast(
          msg: "Invalid image type for single image. Only JPG, PNG, and WEBP are allowed.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
        return;
      }
      singleImageMultipart = await MultipartFile.fromFile(
        singleImage.path,
        filename: singleImage.path.split('/').last,
        contentType: mediaType,
      );
    }

    if (multipleImages != null && multipleImages.isNotEmpty) {
      multipleImagesMultipart = [];
      for (var imageFile in multipleImages) {
        final extension = imageFile.path.split('.').last.toLowerCase();
        MediaType? mediaType;
        if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          mediaType = MediaType('image', extension == 'jpg' ? 'jpeg' : extension);
        } else {
          Fluttertoast.showToast(
            msg: "Invalid image type in multiple images. Only JPG, PNG, and WEBP are allowed.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12,
          );
          return;
        }
        final imageMultipart = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: mediaType,
        );
        multipleImagesMultipart.add(imageMultipart);
      }
    }

    try {
      final formData = FormData.fromMap({
        ...property.toJson(),
        if (singleImageMultipart != null) 'photo': singleImageMultipart,
        if (multipleImagesMultipart != null) 'images[]': multipleImagesMultipart,
      });

      print('FormData Fields: ${formData.fields}');
      print('FormData Files: ${formData.files}');

      final response = await dio.post(
        'https://matrimony.rajveerfacility.in/api/update-properties',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Property submitted successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => RealestateHomePage()));
      } else {
        Fluttertoast.showToast(
          msg: "Submission failed: ${response.data['message'] ?? 'Unknown error'}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response Status: ${e.response?.statusCode}');
      print('Response Headers: ${e.response?.headers}');
      print('Response Data: ${e.response?.data}');
      String errorMessage = "Error: ${e.response?.data['message'] ?? e.message}";
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unexpected error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
    }
  }*/

}