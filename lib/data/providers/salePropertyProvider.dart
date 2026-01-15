


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/FetachPropertyModel.dart';





final salePropertyProvider = FutureProvider.autoDispose<FetachPropertyModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');

  final dio = await createDio();
  final service = APIStateNetwork(dio);
  try {
    final response = await service.fetchPropertiesList(userId.toString());
    if (response.response.statusCode == 200) {
      final filteredProperties = response.data.properties!.where((p) => p.propertyType == 'sale').toList();
      return FetachPropertyModel(properties: filteredProperties);
    } else {
      Fluttertoast.showToast(msg: "Search Failed: ${response.response.statusCode}");
      throw Exception("Search failed");
    }
  } catch (e) {
    throw Exception("API Error: $e");
  }
});
