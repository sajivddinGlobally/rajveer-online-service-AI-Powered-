


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/FetachPropertyModel.dart';
import '../models/rentModel.dart';

final rentListProvider = FutureProvider.autoDispose<RentModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final response = await service.rentPropertiesList( "rent",userId.toString());
    if (response.response.statusCode == 200 ||response.response.statusCode == 201 ) {
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
