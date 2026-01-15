import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final deletePropertyProvider = FutureProvider.family.autoDispose<bool, String>((
  ref,
  propertyId,
) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  // try {
    final response = await service.deleteProperty(
      userId.toString(),
      propertyId,
    );
    if (response.response.statusCode == 200) {
      // Fluttertoast.showToast(msg: "Property deleted successfully");
      // Refresh the favorites list after deletion
      // ref.invalidate(propertyListProvider);
      return true; 
    } else {
      // Fluttertoast.showToast(
      //   msg: "Failed to delete property: ${response.response.statusCode}",
      // );
      throw Exception(
        "you do not own this property",
      );
    }
  // } catch (e) {
  //   // Fluttertoast.showToast(msg: "Delete API Error: ${e.toString()}");
  //   throw Exception("API Error: $e");
  // }
});
