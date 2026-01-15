/*

import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetInterrest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/providers/profileGetDataProvider.dart';


final countryControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final stateControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final cityControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final  livingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final dietControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final smokingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final drinkingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);



class ProfileGetLocation  extends ConsumerWidget {
  const ProfileGetLocation ({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);

    final country = ref.watch(countryControllerProvider);
    final state = ref.watch(stateControllerProvider);
    final city = ref.watch(cityControllerProvider);
    final livingStatus = ref.watch(livingControllerProvider);
    final smoking = ref.watch(smokingControllerProvider);
    final drinking = ref.watch(drinkingControllerProvider);


    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body: 
      profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            country.text = profile.data.profile.country ?? '';
            state.text = profile.data.profile.state ?? '';
            city.text = profile.data.profile.city ?? '';
            livingStatus.text = profile.data.profile.livingStatus ?? '';
            drinking.text = profile.data.profile.drink??'';
            smoking.text = profile.data.profile.smoke??'';
          });

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location & Lifestyle",
                    style: GoogleFonts.gothicA1(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF030016),
                    ),
                  ),
                  Text(
                    "Where Do You Live?",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  _buildLabel("Country"),
                  TextField(
                    enabled: false,
                    controller: country,
                    decoration: _inputDecoration("Enter your Country"),
                  ),
                  SizedBox(height: 15.h),
                  _buildLabel("State"),
                  TextField(
                    enabled: false,
                    controller: state,
                    decoration: _inputDecoration("Enter your State"),
                  ),
                  SizedBox(height: 15.h),
                  _buildLabel("City"),
                  TextField(
                    enabled: false,
                    controller: city,
                    decoration: _inputDecoration("Enter your City"),
                  ),
                  SizedBox(height: 15.h),
                  _buildLabel("Living Status"),
                  TextField(
                    enabled: false,
                    controller: livingStatus,
                    decoration: _inputDecoration("Enter your Living Status"),
                  ),
                  SizedBox(height: 15.h),
                  _buildLabel("Smoking"),
                  TextField(
                    enabled: false,
                    controller: smoking,
                    decoration: _inputDecoration("Enter your Smoking"),
                  ),
                  SizedBox(height: 15.h),
                  _buildLabel("Drink"),
                  TextField(
                    enabled: false,
                    controller: drinking,
                    decoration: _inputDecoration("Enter your Drink"),
                  ),
                  SizedBox(height: 15.h),

                  SizedBox(height: 25.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const ProfileInterestPage(),
                        ),
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
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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

// Custom dropdown widget
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
              color: const Color(0xFF9A97AE), // Gray color for hint
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




import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetInterrest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/providers/profileGetDataProvider.dart';

final countryControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final stateControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final cityControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final livingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final smokingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final drinkingControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

class ProfileGetLocation extends ConsumerWidget {
  const ProfileGetLocation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final country = ref.watch(countryControllerProvider);
    final state = ref.watch(stateControllerProvider);
    final city = ref.watch(cityControllerProvider);
    final livingStatus = ref.watch(livingControllerProvider);
    final smoking = ref.watch(smokingControllerProvider);
    final drinking = ref.watch(drinkingControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            country.text = profile.data.profile.country ?? '';
            state.text = profile.data.profile.state ?? '';
            city.text = profile.data.profile.city ?? '';
            livingStatus.text = profile.data.profile.livingStatus ?? '';
            drinking.text = profile.data.profile.drink ?? '';
            smoking.text = profile.data.profile.smoke ?? '';
          });

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: SingleChildScrollView(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location & Lifestyle",
                    style: GoogleFonts.gothicA1(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF030016),
                    ),
                  ),
                  Text(
                    "Where Do You Live?",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  // Conditionally display fields only if API data is present
                  if (profile.data.profile.country != null && profile.data.profile.country!.isNotEmpty) ...[
                    _buildLabel("Country"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: country,
                      decoration: _inputDecoration("Enter your Country"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.state != null && profile.data.profile.state!.isNotEmpty) ...[
                    _buildLabel("State"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: state,
                      decoration: _inputDecoration("Enter your State"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.city != null && profile.data.profile.city!.isNotEmpty) ...[
                    _buildLabel("City"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: city,
                      decoration: _inputDecoration("Enter your City"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.livingStatus != null && profile.data.profile.livingStatus!.isNotEmpty) ...[
                    _buildLabel("Living Status"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: livingStatus,
                      decoration: _inputDecoration("Enter your Living Status"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.smoke != null && profile.data.profile.smoke!.isNotEmpty) ...[
                    _buildLabel("Smoking"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: smoking,
                      decoration: _inputDecoration("Enter your Smoking"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.drink != null && profile.data.profile.drink!.isNotEmpty) ...[
                    _buildLabel("Drink"),
                    SizedBox(height: 10.h),
                    TextField(
                      enabled: false,
                      controller: drinking,
                      decoration: _inputDecoration("Enter your Drink"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  SizedBox(height: 25.h),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const ProfileInterestPage(),
                        ),
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
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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