//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:hive_flutter/adapters.dart';
//
// import '../../core/network/api.state.dart';
// import '../../core/utils/preety.dio.dart';
//
// final jobResisterEmployerProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, data) async {
//
//     final box = await Hive.openBox('userdata');
//     final userId = box.get('user_id');
//
//     if (userId == null) {
//       throw Exception('User not logged in');
//     }
//     // Merge user ID into the application data
//     final applicationData = {
//       ...data,
//
//     };
//
//     final dio = await createDio();
//     final service = APIStateNetwork(dio);
//
//     final response = await service.resisterEmployer(applicationData);
//
//     if (response.response.statusCode==200 || response.response.statusCode == 201) {
//       Fluttertoast.showToast(
//         msg: response.response.data['message'],
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 12.0,
//       );
//     }else{
//       Fluttertoast.showToast(
//         msg: response.response.data['message'],
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 12.0,
//       );
//     }
//
//
// });
