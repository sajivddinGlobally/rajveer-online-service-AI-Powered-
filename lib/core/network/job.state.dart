import 'dart:io';
import 'package:ai_powered_app/data/models/paymentResModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'job.state.g.dart';

@RestApi(baseUrl: 'https://jobs.rajveerfacility.in/api')
abstract class JobApiNetwork {
  factory JobApiNetwork(Dio dio) = _JobApiNetwork;

  @POST("/payment")
  @MultiPart()
  Future<PaymentResModel> jobPayment(
    @Part(name: "amount") String amount,
    @Part(name: "transaction_id") String transactionId,
    @Part(name: "image") File image,
  );
}
