

// Provider for fetching profile data
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/FavoritesListModel.dart';

final favoritesPropertyListProvider = FutureProvider.autoDispose<FavoritesListModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  try {
    final response = await service.favoritesPropertyList(userId.toString());
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
