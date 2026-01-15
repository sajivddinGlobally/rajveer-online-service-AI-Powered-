


import 'package:ai_powered_app/data/models/RecentPrpertyModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final recentListProvider = FutureProvider.autoDispose<RecentPropertyModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');

  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final response = await service.todayPropertiesList(userId.toString());
    if (response.response.statusCode == 200 || response.response.statusCode == 201) {
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
