import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/RealStateProfileGetModel.dart';

// Provider for fetching profile data
final realStateProfileDataProvider = FutureProvider.autoDispose<RealStateProfileGetModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  try {
    final response = await service.getRealStateProfile(userId.toString());
    if (response.response.statusCode == 200) {
      return response.data;
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch profile: ${response.response.statusCode}");
      throw Exception("Profile fetch failed");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Profile API Error: $e");
    throw Exception("API Error: $e");
  }
});

// Provider for updating profile
final realStateUpdateProfileProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, body) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  try {
    final response = await service.realStateUpdate(userId.toString(), body);
    if (response.response.statusCode == 200) {
      // Invalidate the profile provider to trigger a refetch
      ref.invalidate(realStateProfileDataProvider);
    } else {
      Fluttertoast.showToast(msg: "Failed to update profile: ${response.response.statusCode}");
      throw Exception("Profile update failed");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Profile Update API Error: $e");
    throw Exception("API Error: $e");
  }
});