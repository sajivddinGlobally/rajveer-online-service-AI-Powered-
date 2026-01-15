
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';

final jobApplyProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, data) async {
  try {
    final box = await Hive.openBox('userdata');
    final userId = box.get('user_id');

    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Merge user ID into the application data
    final applicationData = {
      ...data,
      'user_id': userId,
    };

    final dio = await createDio();
    final service = APIStateNetwork(dio);

    final response = await service.applyForJob(applicationData);

    if (response.response.statusCode != 200) {
      throw Exception('Failed to apply for job');
    }

    return; // Success case
  } catch (e) {
    // Let the UI handle the error display
    throw Exception('Application failed: ${e.toString()}');
  }
});
