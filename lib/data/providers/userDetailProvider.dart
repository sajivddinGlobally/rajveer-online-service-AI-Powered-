// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive_flutter/adapters.dart';
//
// import '../../core/network/api.state.dart';
// import '../../core/utils/preety.dio.dart';
// import '../models/profileModel.dart';
//
// final targetUserDetailsProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, userId) async {
//
//
//
//   final dio = await createDio();
//   final service = APIStateNetwork(dio);
//
//   final response = await service.fetchProfile(
//     userId.toString(),
//   );
//
//   if (response.response.statusCode != 200) {
//     Fluttertoast.showToast(msg: "Failed to load profile");
//     throw Exception('Failed to load profile');
//   }
//
//   final profile = response.data;
//
//   // ✅ Save profile locally to Hive
//   final profileBox = await Hive.openBox('profileData');
//   await profileBox.put('profile', profile.toJson());
//
//   // Fluttertoast.showToast(msg: "Profile loaded and cached");
//
//   return profile;
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/MatrimonyProfileDetail.dart';

final targetUserDetailsProvider = FutureProvider.family.autoDispose<DetailModel, String>((ref, userId) async {


  final dio = await createDio();
  final service = APIStateNetwork(dio);

  final response = await service.profileDetail(
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
