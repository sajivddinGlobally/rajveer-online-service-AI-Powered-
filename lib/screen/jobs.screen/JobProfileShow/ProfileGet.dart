import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../../data/providers/jobsProfileGetProvider.dart';
import '../../start.page.dart';
import '../ProfileJobPage.dart';

class ProfileGet extends ConsumerStatefulWidget {
  const ProfileGet({super.key});
  @override
  ConsumerState<ProfileGet> createState() => _ProfileGetState();
}

class _ProfileGetState extends ConsumerState<ProfileGet> {
  final phoneController = TextEditingController();
  final contact_personController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoading = false;
  String? userId;
  String? resumeUrl; // Store the resume URL from API
  final String baseUrl = 'https://matrimony.rajveerfacility.in/public/';
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final profile = await ref.read(jobProfileDataProvider.future);
      setState(() {
        contact_personController.text = profile.user!.name ?? '';
        phoneController.text = profile.user?.phone ?? '';
        emailController.text = profile.user?.email ?? '';
        resumeUrl =
            profile.user?.resume != null
                ? '$baseUrl${profile.user!.resume}'
                : null;
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

  Widget _getFilePreview(dynamic file) {
    if (file is File) {
      // Handle local file
      String fileExtension = file.path.split('.').last.toLowerCase();
      if (fileExtension == 'jpg' ||
          fileExtension == 'jpeg' ||
          fileExtension == 'png') {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      } else if (fileExtension == 'pdf') {
        return Center(
          child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 50),
        );
      } else if (fileExtension == 'doc' || fileExtension == 'docx') {
        return Center(
          child: Icon(Icons.insert_drive_file, color: Colors.blue, size: 50),
        );
      } else {
        return Center(
          child: Text(
            "Selected file: ${file.path.split('/').last}",
            style: TextStyle(color: Colors.black),
          ),
        );
      }
    } else if (file is String) {
      // Handle remote URL
      String fileExtension = file.split('.').last.toLowerCase();
      if (fileExtension == 'jpg' ||
          fileExtension == 'jpeg' ||
          fileExtension == 'png') {
        return CachedNetworkImage(
          imageUrl: file,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder:
              (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      } else if (fileExtension == 'pdf') {
        return Center(
          child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 50),
        );
      } else if (fileExtension == 'doc' || fileExtension == 'docx') {
        return Center(
          child: Icon(Icons.insert_drive_file, color: Colors.blue, size: 50),
        );
      }
    }
    return Center(
      child: Text(
        "Unsupported file format",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    contact_personController.dispose();
    emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(jobProfileDataProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      body: Column(
        children: [
          SizedBox(height: 60.h),
          // ... (Previous Row widget remains the same)
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                child: profileData.when(
                  data:
                      (profile) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
                                final box = await Hive.openBox('userdata');
                                await box.clear(); // Clear saved user data
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => const StartPage(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: Container(
                                width: 103.w,
                                height: 53.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: Color(0xFF0A66C2),
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
                            "Basic Information",
                            style: GoogleFonts.alexandria(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF030016),
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
                                    CupertinoPageRoute(
                                      builder: (_) => const ProfilePageJobs(),
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
                                    color: Color(0xFF0A66C2),
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
                          SizedBox(height: 20.h),
                          _buildLabel("Full Name"),

                          SizedBox(height: 10.h),
                          TextFieldBody(
                            enable: false,
                            keyboardType: TextInputType.text,
                            controller: contact_personController,
                            hint: "Enter Your Name",
                          ),

                          SizedBox(height: 20.h),
                          _buildLabel("Mobile Number"),

                          SizedBox(height: 10.h),
                          TextFieldBody(
                            enable: false,
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            hint: "Enter your mobile number",
                          ),

                          SizedBox(height: 20.h),
                          _buildLabel("Email Address"),
                          SizedBox(height: 10.h),

                          TextFieldBody(
                            enable: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            hint: "Enter your email Address",
                          ),
                          SizedBox(height: 15.h),

                          _buildLabel(
                            "Upload Resume (Pdf, Doc, Docx, jpg, jpeg, png)",
                          ),
                          SizedBox(height: 10.h),

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              height: 150.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5.w,
                                ),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child:
                                  _selectedFile != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        child: _getFilePreview(_selectedFile!),
                                      )
                                      : resumeUrl != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        child: _getFilePreview(resumeUrl!),
                                      )
                                      : Center(
                                        child: Text(
                                          "Upload Document)",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          SizedBox(height: 20.h),
                        ],
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stack) =>
                          Center(child: Text('Error loading profile: $error')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldBody extends StatelessWidget {
  final String hint;
  final bool? enable;
  final TextEditingController controller;
  TextInputType keyboardType = TextInputType.text;
  TextFieldBody({
    super.key,
    required this.hint,
    this.enable,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable,
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
        disabledBorder: OutlineInputBorder(
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
