/*


import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home.page.dart';


final  partnerAgeRangeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerHeightRangeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerEducationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerLocationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());


final partnerNotesControllerProvider =
Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

class profileGetPartnerPreferencePage extends ConsumerStatefulWidget {
  const profileGetPartnerPreferencePage({super.key});
  @override
  ConsumerState<profileGetPartnerPreferencePage> createState() => _profileGetPartnerPreferencePageState();
}

class _profileGetPartnerPreferencePageState extends ConsumerState<profileGetPartnerPreferencePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileDataProvider).maybeWhen(
        data: (profile) => profile.data.profile,
        orElse: () => null,
      );
      if (profile != null) {


        ref.read(partnerNotesControllerProvider).text = profile.partnerNote ?? '';

        ref.read(partnerAgeRangeControllerProvider).text = profile.partnerAgeRange ?? '';
        ref.read(partnerHeightRangeControllerProvider).text = profile.partnerHeightRange ?? '';
        ref.read(partnerEducationControllerProvider).text = profile.partnerEducation ?? '';
        ref.read(partnerLocationControllerProvider).text = profile.partnerLocation ?? '';

      }
    });
  }

  @override
  Widget build(BuildContext context) {




    final age = ref.watch(partnerAgeRangeControllerProvider);
    final height = ref.watch(partnerHeightRangeControllerProvider);
    final education = ref.watch(partnerEducationControllerProvider);
    final location = ref.watch(partnerLocationControllerProvider);
    final notesController = ref.watch(partnerNotesControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Partner Preferences",
              style: GoogleFonts.gothicA1(
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF030016),
              ),
            ),
            Text(
              "What Are You Looking For in a Partner?",
              style: GoogleFonts.gothicA1(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9A97AE),
              ),
            ),
            SizedBox(height: 20.h),

            _buildLabel("Age Range"),
            TextField(
              enabled: false,
              controller: age,
              decoration: _inputDecoration("Enter your Age Range"),
            ),
            SizedBox(height: 15.h),

            _buildLabel("Height Range"),
            TextField(
              enabled: false,
              controller: height,
              decoration: _inputDecoration("Enter your Height Range"),
            ),
            SizedBox(height: 15.h),

            _buildLabel("Education Preference"),
            TextField(
              enabled: false,
              controller: education,
              decoration: _inputDecoration("Enter your Education Preference"),
            ),
            SizedBox(height: 15.h),

            _buildLabel("Location Preference"),
            TextField(
              enabled: false,
              controller: location,
              decoration: _inputDecoration("Enter your Location Preference"),
            ),

            SizedBox(height: 20.h),
            _buildLabel("Notes"),
            TextField(
              enabled: false,
              controller: notesController,
              decoration: _inputDecoration("Enter your Notes"),
            ),

            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () async {




                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                    );

              },
              child: Container(
                width: double.infinity,
                height: 53.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: const Color(0xFF97144d),
                ),
                child: Center(
                  child: Text(
                    "Continue",
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFF97144d), width: 1.w),
      ),
      disabledBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFF97144d), width: 1.w),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9A97AE),
        letterSpacing: -0.2,
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

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF97144d), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.gothicA1(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.gothicA1(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.gothicA1(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF030016),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: (newValue) {
        if (newValue != null) {
          onChange(newValue);
        }
      },
    );
  }
}*/


import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home.page.dart';

final partnerAgeRangeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerHeightRangeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerEducationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerLocationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final partnerNotesControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

class profileGetPartnerPreferencePage extends ConsumerStatefulWidget {
  const profileGetPartnerPreferencePage({super.key});

  @override
  ConsumerState<profileGetPartnerPreferencePage> createState() => _profileGetPartnerPreferencePageState();
}

class _profileGetPartnerPreferencePageState extends ConsumerState<profileGetPartnerPreferencePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileDataProvider).maybeWhen(
        data: (profile) => profile.data.profile,
        orElse: () => null,
      );
      if (profile != null) {
        ref.read(partnerNotesControllerProvider).text = profile.partnerNote ?? '';
        ref.read(partnerAgeRangeControllerProvider).text = profile.partnerAgeRange ?? '';
        ref.read(partnerHeightRangeControllerProvider).text = profile.partnerHeightRange ?? '';
        ref.read(partnerEducationControllerProvider).text = profile.partnerEducation ?? '';
        ref.read(partnerLocationControllerProvider).text = profile.partnerLocation ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final age = ref.watch(partnerAgeRangeControllerProvider);
    final height = ref.watch(partnerHeightRangeControllerProvider);
    final education = ref.watch(partnerEducationControllerProvider);
    final location = ref.watch(partnerLocationControllerProvider);
    final notesController = ref.watch(partnerNotesControllerProvider);
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          // Check if any field has valid data
          final hasData = (profile.data.profile.partnerAgeRange != null && profile.data.profile.partnerAgeRange!.isNotEmpty) ||
              (profile.data.profile.partnerHeightRange != null && profile.data.profile.partnerHeightRange!.isNotEmpty) ||
              (profile.data.profile.partnerEducation != null && profile.data.profile.partnerEducation!.isNotEmpty) ||
              (profile.data.profile.partnerLocation != null && profile.data.profile.partnerLocation!.isNotEmpty) ||
              (profile.data.profile.partnerNote != null && profile.data.profile.partnerNote!.isNotEmpty);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Partner Preferences",
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                Text(
                  "What Are You Looking For in a Partner?",
                  style: GoogleFonts.gothicA1(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                  ),
                ),
                SizedBox(height: 20.h),
                // Conditionally display fields only if API data is present
                if (profile.data.profile.partnerAgeRange != null && profile.data.profile.partnerAgeRange!.isNotEmpty) ...[
                  _buildLabel("Age Range"),
                  SizedBox(height: 15.h),
                  TextField(
                    enabled: false,
                    controller: age,
                    decoration: _inputDecoration("Enter your Age Range"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.partnerHeightRange != null && profile.data.profile.partnerHeightRange!.isNotEmpty) ...[
                  _buildLabel("Height Range"),
                  SizedBox(height: 15.h),
                  TextField(
                    enabled: false,
                    controller: height,
                    decoration: _inputDecoration("Enter your Height Range"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.partnerEducation != null && profile.data.profile.partnerEducation!.isNotEmpty) ...[
                  _buildLabel("Education Preference"),
                  SizedBox(height: 15.h),
                  TextField(
                    enabled: false,
                    controller: education,
                    decoration: _inputDecoration("Enter your Education Preference"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.partnerLocation != null && profile.data.profile.partnerLocation!.isNotEmpty) ...[
                  _buildLabel("Location Preference"),
                  SizedBox(height: 15.h),
                  TextField(
                    enabled: false,
                    controller: location,
                    decoration: _inputDecoration("Enter your Location Preference"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.partnerNote != null && profile.data.profile.partnerNote!.isNotEmpty) ...[
                  _buildLabel("Notes"),
                  SizedBox(height: 15.h),
                  TextField(
                    enabled: false,
                    controller: notesController,
                    decoration: _inputDecoration("Enter your Notes"),
                  ),
                  SizedBox(height: 15.h),
                ],
                // Show Continue button only if at least one field has data
                if (hasData) ...[
                  SizedBox(height: 25.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(builder: (context) => const HomePage()),
                            (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: const Color(0xFF97144d),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
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
              ],
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFF97144d), width: 1.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFF97144d), width: 1.w),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9A97AE),
        letterSpacing: -0.2,
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