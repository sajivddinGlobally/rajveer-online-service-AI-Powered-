import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadResumeScreen extends StatefulWidget {
  const UploadResumeScreen({super.key});

  @override
  State<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  String? selectResume;
  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx"],
    );
    if (result != null && result.files.single.name.isNotEmpty) {
      setState(() {
        selectResume = result.files.single.name;
      });
    } else {
      print("sory");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FA),
      appBar: AppBar(backgroundColor: Color(0xFFF5F8FA)),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Resume",
              style: GoogleFonts.alexandria(
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF030016),
                
              ),
            ),
            Text(
              "Tell us about your resume ",
              style: GoogleFonts.alexandria(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff9A97AE),
                
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                pickResume();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                width: 392.w,
                height: 134.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Color(0xFFDADADA), width: 1.5.w),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        color: Color(0xFFA95C68),
                        size: 30.sp,
                      ),
                      Text(
                        selectResume ?? "Upload your resume ",
                        style: GoogleFonts.alexandria(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9A97AE),
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: Color(0xFFDADADA),
                    width: 1.5.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: Color(0xFFDADADA),
                    width: 1.5.w,
                  ),
                ),
                hintText: "LinkedIn URL",
                hintStyle: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9A97AE),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: Color(0xFFDADADA),
                    width: 1.5.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: Color(0xFFDADADA),
                    width: 1.5.w,
                  ),
                ),
                hintText: "Profile URL",
                hintStyle: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9A97AE),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(builder: (context) => EducationScreen()),
                // );
              },
              child: Container(
                width: 392.w,
                height: 53.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Color(0xFF0A66C2),
                ),
                child: Center(
                  child: Text(
                    "Submit",
                    style: GoogleFonts.alexandria(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
