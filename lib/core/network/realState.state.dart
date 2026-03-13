import 'dart:io';
import 'package:ai_powered_app/data/models/paymentResModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'realState.state.g.dart';

@RestApi(baseUrl: 'https://realestate.rajveerfacility.in/api')
abstract class RealStateState {
  factory RealStateState(Dio dio) = _RealStateState;

  @POST("/payment")
  @MultiPart()
  Future<PaymentResModel> realStatePayment(
    @Part(name: "amount") String amount,
    @Part(name: "transaction_id") String transactionId,
    @Part(name: "image") File image,
  );
}
