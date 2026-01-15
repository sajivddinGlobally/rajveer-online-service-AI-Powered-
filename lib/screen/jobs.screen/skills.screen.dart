import 'package:ai_powered_app/screen/jobs.screen/upload.resume.screen.dart';
import 'package:ai_powered_app/screen/matrimony.screen/profile.page.dart' hide BuildDropDown;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../matrimony.screen/education.page.dart';
import '../matrimony.screen/family.details.page.dart' hide BuildDropDown;
import '../matrimony.screen/partner.preference.page.dart' hide BuildDropDown;
import '../realEstate/createPropertyPage.dart' hide BuildDropDown;
import '../realEstate/location.realEstate.page.dart' hide BuildDropDown;

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  String? skill, category, joblocation, jobType;
  final List<String> skillList = [
    'Flutter',
    'Dart',
    'JavaScript',
    'Python',
    'React',
    'AWS',
    'Git',
    'SQL',
    'Communication',
  ];
  final List<String> categoryList = [
    'Software Engineer',
    'Graphic Designer',
    'Marketing',
    'Sales',
    'Data Analyst',
    'Customer Support',
  ];
  final List<String> jobLocatioinList = [
    'New Delhi',
    'Mumbai',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
    'Remote',
  ];
  final List<String> jobTypeList = [
    "Full-Time",
    "Part-Time",
    "Internship",
    "Freelance",
    "Contract",
    "Temporary",
    "Remote",
    "Hybrid",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FA),
      appBar: AppBar(backgroundColor: Color(0xFFF5F8FA)),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildDropDown(
              hint: "Select Key Skills",
              items: skillList,
              onChange: (value) {
                setState(() {
                  skill = value;
                });
              },
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Job Category",
              items: categoryList,
              onChange: (value) {
                setState(() {
                  category = value;
                });
              },
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Preferred Job Location",
              items: jobLocatioinList,
              onChange: (value) {
                setState(() {
                  joblocation = value;
                });
              },
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Job Type",
              items: jobTypeList,
              onChange: (value) {
                setState(() {
                  jobType = value;
                });
              },
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UploadResumeScreen(),
                  ),
                );
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
                    "Continue",
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
