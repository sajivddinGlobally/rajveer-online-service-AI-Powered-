import 'package:ai_powered_app/data/models/RecentPrpertyModel.dart';
import 'package:ai_powered_app/data/models/deletePhotoBodyModel.dart';
import 'package:ai_powered_app/data/models/deletePhotoResModel.dart';
import 'package:ai_powered_app/data/models/favouriteListBodyModel.dart';
import 'package:ai_powered_app/data/models/favouriteListResModel.dart';
import 'package:ai_powered_app/data/models/passwordChangeBodyModel.dart';
import 'package:ai_powered_app/data/models/sendOTPBodyModel.dart';
import 'package:ai_powered_app/data/models/toggleFavouriteBodyModel.dart';
import 'package:ai_powered_app/data/models/toggleFavouriteResModel.dart';
import 'package:ai_powered_app/data/models/verifyOTPBodyModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/CheckNumberModel.dart';
import '../../data/models/FavoritesListModel.dart';
import '../../data/models/FetachPropertyModel.dart';
import '../../data/models/InquaryModel.dart';
import '../../data/models/InquaryUserModel.dart';
import '../../data/models/JobsProfileGetModel.dart';
import '../../data/models/LoginBodyFirbase.dart';
import '../../data/models/MatchProfileModel.dart';
import '../../data/models/MatrimonyProfileDetail.dart';
import '../../data/models/PaymentCreateModel.dart';
import '../../data/models/PaymentVerifyModel.dart';
import '../../data/models/PropertyAgentUserModel.dart';
import '../../data/models/PropertyDetailModel.dart';
import '../../data/models/RealStateProfileGetModel.dart';
import '../../data/models/employerResisterRequestModel.dart';
import '../../data/models/favratePostModel.dart';
import '../../data/models/jobDetailModel.dart';
import '../../data/models/jobListModel.dart';
import '../../data/models/login.body.dart';
import '../../data/models/profileBasedModel.dart';
import '../../data/models/profileModel.dart';
import '../../data/models/register.req.model.dart';
import '../../data/models/rentModel.dart';
import '../../screen/jobs.screen/myJobScreen.dart';
import 'package:retrofit/http.dart';
part 'api.state.g.dart';

@RestApi(baseUrl: 'https://matrimony.rajveerfacility.in/api')
abstract class APIStateNetwork {
  factory APIStateNetwork(Dio dio) = _APIStateNetwork;

  ////////////////////////////////  Matrimony Api Network ////////////////////////////////////////////
  @POST("/{module}/send-otp")
  Future<SendOtpResModel> sendOtp(
    @Path("module") String module,
    @Body() SendOtpBodyModel body,
  );

  @POST("/{module}/verify-otp")
  Future<VerifyOtpResModel> verifyOtp(
    @Path("module") String module,
    @Body() VerifyOtpBodyModel body,
  );

  @POST("/{module}/reset-password")
  Future<PasswordChangeResModel> resetPassword(
    @Path("module") String module,
    @Body() PasswordChangeBodyModel body,
  );

  // Special case: Main matrimony (no prefix)
  @POST("/send-otp")
  Future<SendOtpResModel> sendOtpMain(@Body() SendOtpBodyModel body);

  @POST("/verify-otp")
  Future<VerifyOtpResModel> verifyOtpMain(@Body() VerifyOtpBodyModel body);

  @POST("/reset-password")
  Future<PasswordChangeResModel> resetPasswordMain(
    @Body() PasswordChangeBodyModel body,
  );

  // Generic Check for All Services
  @POST('/{service}/auth/check-phone-email')
  Future<HttpResponse<dynamic>> checkUserExists({
    @Path('service')
    required String endpoint, // "matrimony" | "job" | "realestate"
    @Body() required CheckBodyResiaterModel body,
  });

  @POST('/matrimony/auth/check-phone-email')
  Future<HttpResponse<dynamic>> checkNumberResister(
    @Body() CheckBodyResiaterModel body,
  );
  @POST('/matrimony/auth/login')
  Future<HttpResponse<dynamic>> login(@Body() LoginBody body);

  @POST('/matrimony/auth/check-phone')
  Future<HttpResponse<dynamic>> checkNumber(@Body() CheckBodyModel body);

  @POST('/matrimony/firebase/auth/login')
  Future<HttpResponse<dynamic>> loginFirbase(@Body() LoginBodyModel body);

  @POST('/matrimony/auth/register')
  Future<HttpResponse<dynamic>> register(@Body() RegisterRequest body);

  @GET('/matrimony/profile/')
  Future<HttpResponse<ProfileModel>> fetchProfile(
    @Query("user_id") String userId,
  );

  @POST('/matrimony/profile/upload-photo')
  @MultiPart()
  Future<HttpResponse<dynamic>> uploadProfilePhoto(
    @Part(name: 'photo[]') List<MultipartFile> photos,
    @Query('user_id') String userId,
  );

  @POST('/matrimony/profile-update')
  Future<HttpResponse<dynamic>> updateProfile(
    @Query("user_id") String userId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/matrimony/search')
  Future<HttpResponse<ProfileBasedModel>> searchProfileBasedQuery(
    @Query('user_id') String userId,
  );

  @POST('/matrimony/match')
  Future<HttpResponse<dynamic>> matchUser(
    @Query('user_id') String userId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/matrimony/matches')
  Future<HttpResponse<MatchProfileModel>> getMatches(
    @Query('user_id') String userId,
  );

  @POST("/matrimony/favorite/list")
  Future<FavouriteListResModel> favouriteList(
    @Body() FavouriteListBodyModel body,
  );

  @POST("/matrimony/favorite/toggle")
  Future<ToggleFavouriteResModel> toggleFavourite(
    @Body() ToggleFavouriteBodyModel body,
  );

  @DELETE("/matrimony/profile/delete-photo?user_id={id}")
  Future<DeletePhotoResModel> deletePhoto(
    @Path() String id,
    @Body() DeletePhotoBodyModel body,
  );

  ///////////////////////////////////// Jobs Api Network //////////////////////////////////////
  @POST('/jobs/auth/login')
  Future<HttpResponse<dynamic>> jobsLogin(@Body() LoginBody body);

  @POST('/job/auth/check-phone')
  Future<HttpResponse<dynamic>> checkNumberJob(@Body() CheckBodyModel body);

  @POST('/job/auth/check-phone-email')
  Future<HttpResponse<dynamic>> checkNumberJobResister(
    @Body() CheckBodyResiaterModel body,
  );

  @POST('/job/firebase/auth/login')
  Future<HttpResponse<dynamic>> loginFirbaseJob(@Body() LoginBodyModel body);

  @POST('/jobs/employer/register')
  Future<HttpResponse<dynamic>> resisterEmployer(
    @Body() EmployerRegisterRequestBody body,
  );

  @GET('/jobs/listings')
  Future<HttpResponse<JobListModel>> getJobListings();

  @GET('/jobs/listing')
  Future<HttpResponse<JobDetailModel>> getJobDetails(
    @Query('job_id') String jobId,
  );

  @POST('/jobs/apply')
  Future<HttpResponse<dynamic>> applyForJob(@Body() Map<String, dynamic> body);

  @GET('/jobs/my-applications')
  Future<HttpResponse<JobApplicationListModel>> getMyJobApplications(
    @Query('user_id') String userId,
  );

  @POST('/jobs/employer/post-job')
  Future<HttpResponse<dynamic>> postJobs(@Body() Map<String, dynamic> body);

  @GET('/jobseeker/profile')
  Future<HttpResponse<JobsProfileGetModel>> getJobsProfile(
    @Query('user_id') String userId,
  );

  //////////////////////////////Real State Network//////////////////////////////////////////////

  @POST('/realestate/auth/login')
  Future<HttpResponse<dynamic>> realStateLogin(@Body() LoginBody body);

  @POST('/realestateuser/auth/check-phone')
  Future<HttpResponse<dynamic>> checkNumberRealState(
    @Body() CheckBodyModel body,
  );

  @POST('/realestateuser/auth/check-phone-email')
  Future<HttpResponse<dynamic>> checkNumberRealStateResister(
    @Body() CheckBodyResiaterModel body,
  );

  @POST('/realestateuser/firebase/auth/login')
  Future<HttpResponse<dynamic>> loginFirbaseRealState(
    @Body() LoginBodyModel body,
  );

  @POST('/realestate/auth/register')
  Future<HttpResponse<dynamic>> registerRealState(@Body() RegisterRequest body);

  @POST('/razorpay/order')
  Future<HttpResponse<dynamic>> razorpayOrder(@Body() PaymentCreateModel body);

  @POST('/razorpay/capture')
  Future<HttpResponse<dynamic>> razorpayOrderVerify(
    @Body() PaymentVerifyModel body,
  );

  @POST('/realestate/createProperty')
  Future<HttpResponse<dynamic>> createProperty(
    @Body() Map<String, dynamic> body,
  );

  @GET('/realestate/properties')
  Future<HttpResponse<FetachPropertyModel>> fetchPropertiesList(
    @Query('user_id') String userId,
  );

  @GET('/realestate/properties')
  Future<HttpResponse<RentModel>> rentPropertiesList(
    @Query('property_type') String jobType,
    @Query('user_id') String userId,
  );

  @GET('/properties/today')
  Future<HttpResponse<RecentPropertyModel>> todayPropertiesList(
    @Query('user_id') String userId,
  );

  @GET('/realestate/getProperty')
  Future<HttpResponse<PropertyDetailModel>> getPropertiesDetail(
    @Query('property_id') String propertyId,
  );

  @POST('/realestate/inquiries')
  Future<HttpResponse<dynamic>> userInquiries(@Body() SendInquiryBody body);

  @GET('/realestate/inquiries/get')
  Future<HttpResponse<InquaryUserListModel>> getUserInquiries(
    @Query('user_id') String userId,
  );

  @POST('/realestate/favorites')
  Future<HttpResponse<dynamic>> userFavorate(@Body() SendFavrateBody body);

  @GET('/properties/profile')
  Future<HttpResponse<RealStateProfileGetModel>> getRealStateProfile(
    @Query('user_id') String userId,
  );

  @POST('/properties/updateProfile')
  Future<HttpResponse<dynamic>> realStateUpdate(
    @Query('user_id') String userId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/book-property')
  Future<HttpResponse<dynamic>> bookProperty(@Body() Map<String, dynamic> body);

  @POST('/getBooking-List')
  Future<HttpResponse<PropertyAgentUserModel>> getPropertyBookList(
    @Query('user_id') String userId,
  );

  @POST('/realestate/properties/update')
  Future<HttpResponse<dynamic>> updateProperty(
    @Query('property_id') String propertyId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/realestate/favorites/get')
  Future<HttpResponse<FavoritesListModel>> favoritesPropertyList(
    @Query('user_id') String userId,
  );

  @DELETE('/realestate/properties/Delete')
  Future<HttpResponse<FavoritesListModel>> deleteProperty(
    @Query('user_id') String userId,
    @Query('property_id') String propertyId,
  );

  @GET('/matrimony/profile/')
  Future<HttpResponse<DetailModel>> profileDetail(
    @Query("user_id") String userId,
  );

  //////////////////// forgot password ///////////////////////////

  @POST("/properties/booking/date")
  Future<HttpResponse<dynamic>> bookingDate(@Body() Map<String, dynamic> body);
}
