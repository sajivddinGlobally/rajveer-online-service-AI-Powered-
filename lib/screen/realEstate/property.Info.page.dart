import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../data/providers/realStateProfileGetProvider.dart';
import '../start.page.dart';

class PropertyInfoPage extends ConsumerStatefulWidget {
  const PropertyInfoPage({super.key});

  @override
  ConsumerState<PropertyInfoPage> createState() => _PropertyInfoPageState();
}

class _PropertyInfoPageState extends ConsumerState<PropertyInfoPage> {
  String? listing, propertyType, BHK;
  final List<String> listingList = [
    "For Rent",
    "For Sale",
    "Lease",
    "PG / Shared",
    "Commercial Property",
    "Land / Plot",
  ];
  final List<String> propertyTypeList = [
    "Apartment / Flat",
    "Independent House / Villa",
    "Studio Apartment",
    "Builder Floor",
    "Penthouse",
    "Office Space",
    "Shop / Showroom",
    "Commercial Building",
    "Co-working Space",
    "Warehouse / Godown",
    "Industrial Shed",
    "Residential Land",
    "Commercial Land",
    "Agricultural Land",
    "Industrial Land",
    "Farm House",
    "PG / Hostel",
    "Hotel / Guest House",
  ];
  final List<String> BHKList = [
    "1 RK",
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "5 BHK",
    "6 BHK+",
  ];

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
        roleController.text = capitalizeFirstWord(profile.data!.role ?? '');
        // roleController.text = profile.data!.role ?? ''; // Assuming role is part of the model
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

  Future<void> _updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a contact person name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter an email address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a phone number",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      };
      await ref.read(realStateUpdateProfileProvider(body).future);
      Fluttertoast.showToast(
        msg: "Profile updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      // Redirect to HomeScreen after successful update
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RealestateHomePage()),
        );
      }
      // The provider already invalidates realStateProfileDataProvider, so UI will update automatically
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating profile: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
              Text(
                "Basic Info",
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF030016),
                  letterSpacing: -1.3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Let's Start with the Basics",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     final box = await Hive.openBox('userdata');
                  //     await box.clear();
                  //     if (context.mounted) {
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(builder: (_) => const StartPage()),
                  //       );
                  //     }
                  //   },
                  //   child: Container(
                  //     width: 103.w,
                  //     height: 53.h,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15.r),
                  //       color: const Color(0xFF00796B),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         "Logout",
                  //         style: GoogleFonts.gothicA1(
                  //           fontSize: 18.sp,
                  //           fontWeight: FontWeight.w500,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 15.h),
              _buildLabel("Full Name"),
              SizedBox(height: 10.h),
              TextField(
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
                 keyboardType: TextInputType.number,
                        inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  // या इससे भी आसान और आम तरीका:
  FilteringTextInputFormatter.digitsOnly,
],
                maxLength: 10,
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
              GestureDetector(
                onTap: isLoading ? null : _updateProfile,
                child: Container(
                  width: 392.w,
                  height: 53.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: isLoading ? Colors.grey : const Color(0xFF00796B),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              "Continue",
                              style: GoogleFonts.inter(
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
