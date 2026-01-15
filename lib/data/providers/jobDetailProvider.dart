import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/network/api.state.dart';
import '../../core/utils/preety.dio.dart';
import '../models/jobDetailModel.dart';

final jobDetailProvider = FutureProvider.family.autoDispose<JobDetailModel, String>((ref, jobId) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  final response = await service.getJobDetails(jobId);

  if (response.response.statusCode != 200) {
    Fluttertoast.showToast(msg: "Failed to load job detail");
    throw Exception('Failed to load job detail');
  }

  return response.data;
});
