import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../data/providers/realStateProfileGetProvider.dart';
import '../../start.page.dart';
import '../property.Info.page.dart';

class ProfileGetRealState extends ConsumerStatefulWidget {
  const ProfileGetRealState({super.key});

  @override
  ConsumerState<ProfileGetRealState> createState() =>
      _ProfileGetRealStateState();
}

class _ProfileGetRealStateState extends ConsumerState<ProfileGetRealState> {
  String? listing, propertyType, BHK;
  bool isLoading = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  String capitalizeFirstWord(String text) {
    if (text.isEmpty) return text;
    // Split by space to get the first word
    List<String> words = text.split(' ');
    if (words.isEmpty) return text;
    // Capitalize the first letter of the first word
    words[0] =
        words[0].isNotEmpty
            ? '${words[0][0].toUpperCase()}${words[0].substring(1)}'
            : words[0];
    // Join the words back
    return words.join(' ');
  }
  Future<void> _loadProfile() async {
    try {
      final profile = await ref.read(realStateProfileDataProvider.future);
      setState(() {
        nameController.text = profile.data!.name ?? '';
        phoneController.text = profile.data!.phone ?? '';
        emailController.text = profile.data!.email ?? '';
        // roleController.text = profile.data!.role ?? ''; // Assuming role is part of the model
        roleController.text = capitalizeFirstWord(profile.data!.role ?? '');
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load profile data: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ Prevents auto-back
        title: Text(
          "My Profile",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00796B),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    final box = await Hive.openBox('userdata');
                    await box.clear();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const StartPage()),
                      );
                    }
                  },
                  child: Container(
                    width: 103.w,
                    height: 53.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: const Color(0xFF00796B),
                    ),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: GoogleFonts.gothicA1(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Basic Info",
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF030016),
                  letterSpacing: -1.3,
                ),
              ),
              Text(
                "Let's Start with the Basics",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9A97AE),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PropertyInfoPage(),
                        ),
                      );
                    },
                    child: Container(
                      // width: 113.w,
                      // height: 53.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: const Color(0xFF00796B),
                      ),
                      child: Center(
                        child: Text(
                          "Edit Profile",
                          style: GoogleFonts.gothicA1(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              _buildLabel("Full Name"),
              SizedBox(height: 10.h),
              TextField(
                enabled: false,
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  hintText: "Enter Name",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Email"),
              SizedBox(height: 10.h),
              TextField(
                enabled: false,
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  hintText: "Enter Email",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Mobile Number"),
              SizedBox(height: 10.h),
              TextField(
                maxLength: 10,
                enabled: false,
                controller: phoneController,
                decoration: InputDecoration(
                  counterText: '',

                  contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  hintText: "Enter Mobile Number",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Select Role"),
              SizedBox(height: 10.h),
              TextField(
                enabled: false,
                controller: roleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFDADADA),
                      width: 1.5.w,
                    ),
                  ),
                  hintText: "Enter Role",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF030016),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),

    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.dispose();
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
