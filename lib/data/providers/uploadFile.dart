
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final uploadProfilePhotosProvider =
FutureProvider.family.autoDispose<void, List<File>>((ref, images) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  final token = box.get('token');
  if (userId == null || token == null) {
    throw Exception('Missing user ID or token');
  }

  final dio = await createDio(); // Your Dio setup method
  final service = APIStateNetwork(dio);

  final List<MultipartFile> multipartFiles = await Future.wait(
    images.map((file) async {
      return await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType("image", "jpeg"),
      );
    }),
  );

  final response = await service.uploadProfilePhoto(
    multipartFiles,
    userId.toString(),
  );

  if (response.response.statusCode != 201) {
    throw Exception("Photo upload failed");
  }
});
