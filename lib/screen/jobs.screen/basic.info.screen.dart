import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../matrimony.screen/education.page.dart';
import '../matrimony.screen/family.details.page.dart' hide BuildDropDown;
import '../matrimony.screen/partner.preference.page.dart' hide BuildDropDown;
import '../realEstate/createPropertyPage.dart' hide BuildDropDown;
import '../realEstate/location.realEstate.page.dart' hide BuildDropDown;
import 'education.screen.dart';
import 'home.screen.dart';


class BasicInfoScreen extends StatefulWidget {
  const
  BasicInfoScreen({super.key});
  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementController = TextEditingController();
  final locationController = TextEditingController();
  final employmentController = TextEditingController();
  final Map<String, String> employmentMap = {
    'Full Time': 'full_time',
    'Part Time': 'part_time',
  };

  List<String> options = [];
  String? employmentType;


  @override
  void initState() {
    super.initState();
    options = employmentMap.keys.toList();
    if (employmentController.text.isNotEmpty) {
      employmentType = employmentMap.entries
          .firstWhere(
            (entry) => entry.value == employmentController.text,
        orElse: () => const MapEntry('', ''),
      ).key;
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
        );
        return false;
      },
      child:
      Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
        appBar: AppBar(backgroundColor: const Color(0xFFF5F8FA)),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Employer Post Job",
                style: GoogleFonts.alexandria(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF030016),
                  
                ),
              ),
              SizedBox(height: 20.h),
              _buildLabel("Title"),
              SizedBox(height: 10.h),
              TextFieldBody(controller: titleController, hint: "Enter Your title", keyboardType: TextInputType.text,),
              SizedBox(height: 20.h),
              _buildLabel("Description"),
              SizedBox(height: 10.h),
              TextFieldBody(controller: descriptionController, hint: "Enter Your Description" ,keyboardType: TextInputType.text,),
              SizedBox(height: 20.h),
              _buildLabel("Requirement"),
              SizedBox(height: 10.h),
              TextFieldBody(controller: requirementController, hint: "Enter Your Requirement", keyboardType: TextInputType.text,),
              SizedBox(height: 20.h),
              _buildLabel("Location"),
              SizedBox(height: 10.h),
              TextFieldBody(controller: locationController, hint: "Enter Your Location", keyboardType: TextInputType.text,),
              SizedBox(height: 20.h),
              _buildLabel("Employment"),
              SizedBox(height: 10.h),
              BuildDropDown(
                hint: "Select Employment Type",
                items: options,
                value: employmentType,
                onChange: (val) {
                  setState(() {
                    employmentType = val;
                    employmentController.text = employmentMap[val] ?? '';
                  });
                },
              ),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () {
                  if (titleController.text.isEmpty ||
                      employmentController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      requirementController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all the fields')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EducationScreen(
                        title: titleController.text,
                        employment: employmentController.text,
                        location: locationController.text,
                        requirement: requirementController.text,
                        description: descriptionController.text,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 53.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: const Color(0xFF0A66C2),
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
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }

}


class TextFieldBody extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  TextInputType keyboardType = TextInputType.text;
  TextFieldBody({
    super.key,
    required this.hint,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.alexandria(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
