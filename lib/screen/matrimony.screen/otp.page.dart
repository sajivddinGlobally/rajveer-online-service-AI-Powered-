import 'package:ai_powered_app/screen/start.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(backgroundColor: Color(0xFFFFFFFF)),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your OTP",
              style: GoogleFonts.gothicA1(
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF030016),
                
              ),
            ),
            Text.rich(
              TextSpan(
                text: "OTP has been sent to your number",
                style: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9A97AE),
                  
                ),
                children: [
                  TextSpan(
                    text: " +91-7865452122",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9A97AE),
                      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            OtpPinField(
              maxLength: 6,
              fieldHeight: 50.h,
              fieldWidth: 55.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               keyboardType: TextInputType.number,

              otpPinFieldDecoration:
                  OtpPinFieldDecoration.defaultPinBoxDecoration,
              otpPinFieldStyle: const OtpPinFieldStyle(
                activeFieldBorderColor: Color(0xFF97144d),
                defaultFieldBorderColor: Color(0xFFC8C8C8),
                fieldBorderRadius: 8,
                fieldBorderWidth: 1.5,
              ),
              onSubmit: (text) {},
              onChange: (text) {},
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => StartPage()),
                );
              },
              child: Container(
                width: 392.w,
                height: 53.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Color(0xFFE6E1D8),
                ),
                child: Center(
                  child: Text(
                    'Verify OTP',
                    style: GoogleFonts.gothicA1(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9A97AE),
                      
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
