import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../../screen/jobs.screen/myJobScreen.dart';
import '../models/InquaryUserModel.dart';
import '../models/jobApplicationModel.dart';
final inquaryListProvider = FutureProvider.autoDispose<InquaryUserListModel>((ref) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');

  if (userId == null) {
    Fluttertoast.showToast(msg: "User ID not found in Hive.");
    throw Exception("User ID is missing");
  }

  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final response = await service.getUserInquiries(userId.toString());
    final statusCode = response.response.statusCode ?? 0;
    final body = response.response.data;

    if (statusCode == 200 || statusCode == 201) {
      print("API Success: ${response.data.inquiries?.length ?? 0} inquiries found");
      return response.data;
    }



    Fluttertoast.showToast(msg: body['message'] ?? "Search failed: $statusCode");
    throw Exception("Search failed: ${body['message'] ?? 'Unknown error'}");
  } catch (e) {
    print("API Error: $e");
    // Fluttertoast.showToast(msg: "Search API Error");
    throw Exception("API Error: $e");
  }
});