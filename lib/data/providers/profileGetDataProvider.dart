import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/profileModel.dart';


final profileDataProvider = FutureProvider.autoDispose<ProfileModel>((ref) async {
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
  final response = await service.fetchProfile(
    userId.toString(),
  );
  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Failed to load profile");
    throw Exception('Failed to load profile');
  }
  final profile = response.data;
  // ✅ Save profile locally to Hive
  final profileBox = await Hive.openBox('profileData');
  await profileBox.put('profile', profile.toJson());
  // Fluttertoast.showToast(msg: "Profile loaded and cached");
  return profile;
});
