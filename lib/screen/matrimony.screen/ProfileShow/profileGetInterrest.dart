/*
import 'dart:convert';
import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetEducation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/providers/profileGetDataProvider.dart';

class ProfileInterestPage extends ConsumerStatefulWidget {
  const ProfileInterestPage({super.key});

  @override
  ConsumerState<ProfileInterestPage> createState() => _ProfileInterestPageState();
}

class _ProfileInterestPageState extends ConsumerState<ProfileInterestPage> {
  Set<String> selectedInterests = {};
  final List<String> interestList = [
    "Music","Reading","Cricket",  "Art","Test", "Technology", "Science", "Literature",
    "Travel", "Food", "Fashion", "Health", "Fitness",
    "Photography", "Gaming", "Nature", "History", "Education",
    "Finance", "Sports", "Theater", "Crafts",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileData = ref.read(profileDataProvider).maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    if (profileData != null && selectedInterests.isEmpty) {
      final existing = profileData.data.profile.interest;  // Example: "Music, Travel, Food"

      if (existing != null && existing.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(existing);
          final parsed = decoded
              .map((e) => e.toString().trim())
              .where((e) => interestList.contains(e))
              .toSet();

          setState(() {
            selectedInterests = parsed;
          });
        } catch (e) {
          print("Failed to decode interest: $e");
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: Color(0xFFFDF6F8), elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interest",
              style: GoogleFonts.gothicA1(
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF030016),

              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Select all of your hobbies and interest to match with partner",
              style: GoogleFonts.gothicA1(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9A97AE),

              ),
            ),
            SizedBox(height: 25.h),

            /// Interests as FilterChips
            Wrap(
              runSpacing: 10.w,
              spacing: 10.h,
              children: interestList.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color:isSelected?Colors.white:  Color(0xFF030016),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  selected: isSelected,
                  showCheckmark: false, 
                  selectedColor: Color(0xFF97144d),
                  backgroundColor: Color(0xFFF2D4DC), 
                  onSelected:null
                );
              }).toList(),
            ),

            SizedBox(height: 30.h),

            /// Continue Button
            GestureDetector(
              onTap: () {

                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => profileGetEducation()),
                );


              },


              child: Container(
                width: double.infinity,
                height: 53.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Color(0xFF97144d),
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
}
*/



import 'dart:convert';
import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetEducation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/providers/profileGetDataProvider.dart';

class ProfileInterestPage extends ConsumerStatefulWidget {
  const ProfileInterestPage({super.key});

  @override
  ConsumerState<ProfileInterestPage> createState() => _ProfileInterestPageState();
}

class _ProfileInterestPageState extends ConsumerState<ProfileInterestPage> {
  Set<String> selectedInterests = {};
  final List<String> interestList = [
    "Music", "Reading", "Cricket", "Art", "Test", "Technology", "Science", "Literature",
    "Travel", "Food", "Fashion", "Health", "Fitness",
    "Photography", "Gaming", "Nature", "History", "Education",
    "Finance", "Sports", "Theater", "Crafts",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileData = ref.read(profileDataProvider).maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    if (profileData != null && selectedInterests.isEmpty) {
      final existing = profileData.data.profile.interest;

      if (existing != null && existing.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(existing);
          final parsed = decoded
              .map((e) => e.toString().trim())
              .where((e) => interestList.contains(e))
              .toSet();

          setState(() {
            selectedInterests = parsed;
          });
        } catch (e) {
          print("Failed to decode interest: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: Color(0xFFFDF6F8), elevation: 0),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {

          final hasData = profile.data.profile.interest != null &&
              profile.data.profile.interest!.isNotEmpty &&
              selectedInterests.isNotEmpty;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Interest",
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF030016),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Select all of your hobbies and interest to match with partner",
                  style: GoogleFonts.gothicA1(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9A97AE),
                  ),
                ),
                SizedBox(height: 25.h),
                // Conditionally display interests only if API data is present
                if (hasData) ...[

                  // Wrap(
                  //   runSpacing: 10.w,
                  //   spacing: 10.h,
                  //   children: interestList.map((interest) {
                  //     final isSelected = selectedInterests.contains(interest);
                  //     return FilterChip(
                  //       label:
                  //       Text(
                  //         interest,
                  //         style: TextStyle(
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w400,
                  //           color: isSelected ? Colors.white : Color(0xFF030016),
                  //         ),
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15.r),
                  //       ),
                  //       selected: isSelected,
                  //       showCheckmark: false,
                  //       selectedColor: Color(0xFF97144d),
                  //       backgroundColor: Color(0xFFF2D4DC),
                  //       onSelected: null,
                  //     );
                  //   }).toList(),
                  // ),

                  // Wrap(
                  //   runSpacing: 10.w,
                  //   spacing: 10.h,
                  //   children: interestList.map((interest) {
                  //     final isSelected = selectedInterests.contains(interest);
                  //     return FilterChip(
                  //       label: Text(
                  //         interest,
                  //         style: TextStyle(
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w400,
                  //           color: isSelected ? Colors.white.withOpacity(1.0) : const Color(0xFF030016),
                  //         ),
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15.r),
                  //       ),
                  //       selected: isSelected,
                  //       showCheckmark: false,
                  //       selectedColor: const Color(0xFF97144d),
                  //       backgroundColor: const Color(0xFFF2D4DC),
                  //       onSelected: null,
                  //       // Explicitly set label style to avoid theme interference
                  //       labelStyle: TextStyle(
                  //         fontSize: 16.sp,
                  //         fontWeight: FontWeight.w400,
                  //         color: isSelected ? Colors.white.withOpacity(1.0) : const Color(0xFF030016),
                  //       ),
                  //       // Disable material tap target overlay to prevent color blending
                  //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //     );
                  //   }).toList(),
                  // ),


                  // Theme(
                  //   data: Theme.of(context).copyWith(
                  //     chipTheme: ChipThemeData(
                  //       labelStyle: GoogleFonts.gothicA1(
                  //         fontSize: 16.sp,
                  //         fontWeight: FontWeight.w400,
                  //         color: Colors.white, // Default for selected chips
                  //       ),
                  //       secondaryLabelStyle: GoogleFonts.gothicA1(
                  //         fontSize: 16.sp,
                  //         fontWeight: FontWeight.w400,
                  //         color: const Color(0xFF030016), // Default for unselected chips
                  //       ),
                  //       selectedColor: const Color(0xFF97144d),
                  //       backgroundColor: const Color(0xFFF2D4DC),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15.r),
                  //       ),
                  //       showCheckmark: false,
                  //     ),
                  //   ),
                  //   child: Wrap(
                  //     runSpacing: 10.w,
                  //     spacing: 10.h,
                  //     children: interestList.map((interest) {
                  //       final isSelected = selectedInterests.contains(interest);
                  //       return FilterChip(
                  //         label: Text(
                  //           interest,
                  //           style: GoogleFonts.gothicA1(
                  //             fontSize: 16.sp,
                  //             fontWeight: FontWeight.w400,
                  //             color: isSelected ? Colors.white : const Color(0xFF030016),
                  //           ),
                  //         ),
                  //         selected: isSelected,
                  //         showCheckmark: false,
                  //         onSelected: null,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),


          Wrap(
          runSpacing: 10.w,
          spacing: 10.h,
          children: interestList.map((interest) {
          final isSelected = selectedInterests.contains(interest);
          return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF97144d) : const Color(0xFFF2D4DC),
          borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
          interest,
          style: GoogleFonts.gothicA1(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: isSelected ? Colors.white : const Color(0xFF030016),
          ),
          ),
          );
          }).toList(),),

                  SizedBox(height: 30.h),

                ],
                // Show Continue button only if there is valid data
                if (hasData) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => profileGetEducation()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Color(0xFF97144d),
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
}