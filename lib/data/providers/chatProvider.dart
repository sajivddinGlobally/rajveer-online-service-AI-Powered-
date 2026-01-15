
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/network/chatService.dart';
import '../../core/utils/preety.dio.dart';
import '../models/InboxModel.dart';

final inboxProvider = FutureProvider.family
    .autoDispose<InboxListResponse, String>((ref, id) async {
  final api = ChatService(createDio2());
  return await api.getInboxs(id);
});

final chatHistoryController = FutureProvider.family((ref, userid) async {
  var box = Hive.box("userdata");
  final id = box.get('user_id').toString();   // logged-in user
  final api = ChatService(createDio2());
  return await api.chatHistory(id, userid.toString()); // receiver user
});


final markSeenController = FutureProvider.family((ref, conversationId) async {
  var box = Hive.box("userdata");
  final userId = box.get('userid').toString();

  final api = ChatService(createDio2());

  // ✔ Correct order: first conversationId then userId
  return await api.markSeen(conversationId.toString(), userId);
});
