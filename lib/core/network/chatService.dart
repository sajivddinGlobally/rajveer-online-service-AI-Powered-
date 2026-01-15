import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/InboxModel.dart';
import '../../data/models/chatHistoryModel.dart';
part 'chatService.g.dart';

@RestApi(baseUrl: "https://api.rajveerfacility.in")

abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;

  @GET("/matrimonies/chats/inbox/{id}")
  Future<InboxListResponse> getInboxs(@Path('id') String id);


  @GET("/matrimonies/chats/history/{userid1}/{userid2}")
  Future<chatHistoryResModel> chatHistory(
      @Path('userid1') String userid1, @Path('userid2') String userid2);


  @POST("/matrimonies/chats/mark_seen/{conversation_id}/{user_id}")
  Future<HttpResponse<dynamic>> markSeen(
      @Path('conversation_id') String conversationId,
      @Path('user_id') String userId,
      );


}


