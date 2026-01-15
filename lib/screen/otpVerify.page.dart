import 'dart:developer';

import 'package:ai_powered_app/core/network/api.state.dart';
import 'package:ai_powered_app/core/utils/preety.dio.dart';
import 'package:ai_powered_app/data/models/verifyOTPBodyModel.dart';
import 'package:ai_powered_app/screen/changePassword.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../data/models/sendOTPBodyModel.dart';

class OtpVerifyPage extends StatefulWidget {
  final String email;
  final String title;
  const OtpVerifyPage(this.title, {super.key, required this.email});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String otpValue = "";
  bool isLoading = false;
  bool isResending = false; // Added to track resend OTP loading state
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();




  String get modulePath {
    switch (widget.title.toUpperCase()) {
      case "JOBS":
        return "job";
      case "REAL ESTATE":
        return "realestate";
      case "MATRIMONY":
      default:
        return ""; // empty means root (/send-otp)
    }
  }

  bool get isMainMatrimony => modulePath.contains("MATRIMONY");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 0,
                    bottom: 0,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(height: 20.h),
              Center(child: Image.asset("assets/loginlogo.png")),
              SizedBox(height: 30.h),
              Divider(color: Colors.black12, thickness: 1),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Enter OTP Code",
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              OtpPinField(
                key: _otpPinFieldController,
                maxLength: 6,
                fieldHeight: 55.h,
                fieldWidth: 55.w,
                 keyboardType:
                 TextInputType.number,

                otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onSubmit: (text) {
                  otpValue = text;
                },
                onChange: (text) {},
              ),
              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final body = VerifyOtpBodyModel(
                        email: widget.email,
                        otp: otpValue,
                      );

                      final service = APIStateNetwork(createDio());
                      // final response = await service.verifyOTP(body);
                      final response;


                      if (isMainMatrimony) {
                        response =   await service.verifyOtpMain(body);
                      } else {
                        response  = await service.verifyOtp(modulePath, body);
                      }


                      // SUCCESS – status 200
                      if (response != null) {
                        setState(() => isLoading = false);

                        Fluttertoast.showToast(
                          msg: "OTP Verified Successfully",
                        );

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder:
                                (context) => ChangePasswordPage(
                                  emal: widget.email,
                                  widget.title,
                                ),
                          ),
                        );
                      }
                      // RESPONSE FALSE
                      else {
                        setState(() => isLoading = false);
                        _otpPinFieldController.currentState!.controller.clear();

                        Fluttertoast.showToast(
                          msg: response?.message ?? "Something went wrong",
                        );
                      }
                    }
                    on DioException catch (e) {
                      setState(() => isLoading = false);

                      final serverMessage =
                          e.response?.data?["message"] ?? "Invalid OTP";

                      Fluttertoast.showToast(msg: serverMessage);
                    } catch (e) {
                      setState(() => isLoading = false);

                      Fluttertoast.showToast(msg: "Error: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getLoginButtonColor(widget.title),
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                  child:
                      isLoading
                          ? Center(
                            child: SizedBox(
                              width: 30.w,
                              height: 30.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ),
                            ),
                          )
                          : Text(
                            "Verify",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isResending = true;
                    });
                    try {
                      final body =   SendOtpBodyModel(
                        email: widget.email
                      );

                      final service = APIStateNetwork(createDio());
                      // final response = await service.verifyOTP(body);

                      final response;


                      if (isMainMatrimony) {
                        response =   await service.sendOtpMain(body);
                      } else {
                        response  = await service.sendOtp(modulePath, body);
                      }

                      // SUCCESS – status 200
                      if (response != null) {
                        setState(() => isResending = false);

                        Fluttertoast.showToast(msg: "OTP Send to your email");
                      }
                      // RESPONSE FALSE
                      else {
                        setState(() => isResending = false);

                        Fluttertoast.showToast(
                          msg: response?.message ?? "Something went wrong",
                        );
                      }
                    } on DioException catch (e) {
                      setState(() => isResending = false);

                      final serverMessage =
                          e.response?.data?["message"] ?? "Invalid OTP";

                      Fluttertoast.showToast(msg: serverMessage);
                    } catch (e) {
                      setState(() => isResending = false);

                      Fluttertoast.showToast(msg: "Error: $e");
                    }
                  },
                  child:
                      isResending
                          ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _getLoginButtonColor(widget.title),
                            ),
                          )
                          : Text(
                            "Resend OTP",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: _getLoginButtonColor(widget.title),
                            ),
                          ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLoginButtonColor(String title) {
    switch (title.toUpperCase()) {
      case "MATRIMONY":
        return const Color(0xFF97144d);
      case "JOBS":
        return const Color(0xFF0A66C2);
      case "REAL ESTATE":
        return const Color(0xFF00796B);
      default:
        return const Color(0xFF97144d);
    }
  }
}
