
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final sentInterestProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, data) async {
  final box = await Hive.openBox('userdata');
  final userId = box.get('user_id');
  print('User ID: $userId');
  if (userId == null) {
    throw Exception('Missing user ID or token');
  }
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  final response = await service.matchUser(
    userId.toString(),
    data,
  );

  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Failed to Interest sent ");
    throw Exception('Interest sent  failed');
  }


  Fluttertoast.showToast(msg: "Interest sent successfully");

});
