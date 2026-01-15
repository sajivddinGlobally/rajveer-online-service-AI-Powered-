import 'package:ai_powered_app/screen/matrimony.screen/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final updateProfileProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, data) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  final token = box.get('token');

  print('User ID: $userId');
  print('Token: $token');

  if (userId == null || token == null) {
    throw Exception('Missing user ID or token');
  }

  final dio = await createDio();
  final service = APIStateNetwork(dio);
  final response = await service.updateProfile(
    userId.toString(),
    data,
  );
  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Failed to update profile");
    throw Exception('Profile update failed');
  }
  Fluttertoast.showToast(msg: "Profile updated successfully");

});
