import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/profileBasedModel.dart';


final profileBasedSearchProvider = FutureProvider.autoDispose<ProfileBasedModel>((ref) async {
  await ref.watch(profileDataProvider.future); // ensure data is loaded
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  try {
    final response = await service.searchProfileBasedQuery(userId.toString());

    if (response.response.statusCode == 200) {

      return response.data;
    } else {
      Fluttertoast.showToast(msg: "Search Failed: ${response.response.statusCode}");
      throw Exception("Search failed");
    }
  } catch (e) {
    // Fluttertoast.showToast(msg: "Search API Error");
    throw Exception("API Error: $e");
  }
});
