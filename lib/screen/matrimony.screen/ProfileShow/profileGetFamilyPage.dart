

/*

import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetPartnerPrefrence.dart';
import 'package:ai_powered_app/screen/matrimony.screen/partner.preference.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
final fatherOccupationController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final motherOccupationController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final familyTypeController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
class profileGetFamilyPage extends ConsumerStatefulWidget {
  const profileGetFamilyPage({super.key});
  @override
  ConsumerState<profileGetFamilyPage> createState() => _profileGetFamilyPageState();
}
class _profileGetFamilyPageState extends ConsumerState<profileGetFamilyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileDataProvider).maybeWhen(
        data: (profile) => profile.data.profile,
        orElse: () => null,
      );

      if (profile != null) {
        final fatherOccupation = ref.read(fatherOccupationController);
        final motherOccupation = ref.read(motherOccupationController);
        final familyType = ref.read(familyTypeController);
        if (fatherOccupation.text.isEmpty) fatherOccupation.text = profile.fatherOccupation ?? '';
        if (motherOccupation.text.isEmpty) motherOccupation.text = profile.motherOccupation ?? '';
        if (familyType.text.isEmpty) familyType.text = profile.familyType ?? '';

      }
    });
  }

  @override
  Widget build(BuildContext context) {


    final profileAsync = ref.watch(profileDataProvider);

    final fatherOccupation = ref.watch(fatherOccupationController);
    final motherOccupation = ref.watch(motherOccupationController);
    final familyType = ref.watch(familyTypeController);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F8),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const PartnerPreferencePage()),
              );
            },
            child: Container(
              width: 67.w,
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: const Color(0xFFF2D4DC),
              ),
              child: Center(
                child: Text(
                  "Skip",
                  style: GoogleFonts.gothicA1(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF97144d),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Family Details",
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                Text(
                  "A Little About Your Family",
                  style: GoogleFonts.gothicA1(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                  ),
                ),
                SizedBox(height: 20.h),
                // BuildDropDown(
                //   hint: "Select Father's Occupation",
                //   items: fatherOccupationList,
                //   value: fatherOccupation,
                //   onChange: (value) => ref.read(fatherOccupationProvider.notifier).state = value,
                // ),
                _buildLabel("Father's Occupation"),
                TextField(
                  enabled: false,
                  controller: fatherOccupation,
                  decoration: _inputDecoration("Enter your Father's Occupationn"),
                ),
                SizedBox(height: 15.h),
                // BuildDropDown(
                //   hint: "Select Mother's Occupation",
                //   items: motherOccupationList,
                //   value: motherOccupation,
                //   onChange: (value) => ref.read(motherOccupationProvider.notifier).state = value,
                // ),
                _buildLabel("Mother's Occupation"),
                TextField(
                  enabled: false,
                  controller: motherOccupation,
                  decoration: _inputDecoration("Enter your Mother's Occupation"),
                ),
                SizedBox(height: 15.h),
                // BuildDropDown(
                //   hint: "Select Family Type",
                //   items: familyTypeList,
                //   value: familyType,
                //   onChange: (value) => ref.read(familyTypeProvider.notifier).state = value,
                // ),
                _buildLabel("Family Type"),
                TextField(
                  enabled: false,
                  controller: familyType,
                  decoration: _inputDecoration("Enter your Family Type"),
                ),

                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {
                    if (fatherOccupation == null ||
                        motherOccupation == null ||
                        familyType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select all required fields")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const profileGetPartnerPreferencePage()),
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




import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetPartnerPrefrence.dart';
import 'package:ai_powered_app/screen/matrimony.screen/partner.preference.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final fatherOccupationController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final motherOccupationController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final familyTypeController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

class profileGetFamilyPage extends ConsumerStatefulWidget {
  const profileGetFamilyPage({super.key});

  @override
  ConsumerState<profileGetFamilyPage> createState() => _profileGetFamilyPageState();
}

class _profileGetFamilyPageState extends ConsumerState<profileGetFamilyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileDataProvider).maybeWhen(
        data: (profile) => profile.data.profile,
        orElse: () => null,
      );

      if (profile != null) {
        final fatherOccupation = ref.read(fatherOccupationController);
        final motherOccupation = ref.read(motherOccupationController);
        final familyType = ref.read(familyTypeController);
        if (fatherOccupation.text.isEmpty) fatherOccupation.text = profile.fatherOccupation ?? '';
        if (motherOccupation.text.isEmpty) motherOccupation.text = profile.motherOccupation ?? '';
        if (familyType.text.isEmpty) familyType.text = profile.familyType ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);
    final fatherOccupation = ref.watch(fatherOccupationController);
    final motherOccupation = ref.watch(motherOccupationController);
    final familyType = ref.watch(familyTypeController);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F8),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const PartnerPreferencePage()),
              );
            },
            child: Container(
              width: 67.w,
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: const Color(0xFFF2D4DC),
              ),
              child: Center(
                child: Text(
                  "Skip",
                  style: GoogleFonts.gothicA1(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF97144d),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (profile) {
          // Check if any field has valid data
          final hasData = (profile.data.profile.fatherOccupation != null && profile.data.profile.fatherOccupation!.isNotEmpty) ||
              (profile.data.profile.motherOccupation != null && profile.data.profile.motherOccupation!.isNotEmpty) ||
              (profile.data.profile.familyType != null && profile.data.profile.familyType!.isNotEmpty);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Family Details",
                    style: GoogleFonts.gothicA1(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF030016),
                    ),
                  ),
                  Text(
                    "A Little About Your Family",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Conditionally display fields only if API data is present
                  if (profile.data.profile.fatherOccupation != null && profile.data.profile.fatherOccupation!.isNotEmpty) ...[
                    _buildLabel("Father's Occupation"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                      controller: fatherOccupation,
                      decoration: _inputDecoration("Enter your Father's Occupation"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.motherOccupation != null && profile.data.profile.motherOccupation!.isNotEmpty) ...[
                    _buildLabel("Mother's Occupation"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                      controller: motherOccupation,
                      decoration: _inputDecoration("Enter your Mother's Occupation"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.familyType != null && profile.data.profile.familyType!.isNotEmpty) ...[
                    _buildLabel("Family Type"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                      controller: familyType,
                      decoration: _inputDecoration("Enter your Family Type"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  // Show "Continue" button only if at least one field has data
                  if (hasData) ...[
                    SizedBox(height: 25.h),
                    GestureDetector(
                      onTap: () {
                        // Validate only displayed fields
                        bool hasError = false;
                        if (profile.data.profile.fatherOccupation != null && profile.data.profile.fatherOccupation!.isNotEmpty && fatherOccupation.text.isEmpty) {
                          hasError = true;
                        }
                        if (profile.data.profile.motherOccupation != null && profile.data.profile.motherOccupation!.isNotEmpty && motherOccupation.text.isEmpty) {
                          hasError = true;
                        }
                        if (profile.data.profile.familyType != null && profile.data.profile.familyType!.isNotEmpty && familyType.text.isEmpty) {
                          hasError = true;
                        }
                        if (hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please ensure all displayed fields are filled")),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => const profileGetPartnerPreferencePage()),
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