


import 'package:ai_powered_app/data/models/PropertyDetailModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';


final propertyDetailProvider = FutureProvider.autoDispose.family<PropertyDetailModel, int>((ref, propertyId) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final response = await service.getPropertiesDetail(propertyId.toString());
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