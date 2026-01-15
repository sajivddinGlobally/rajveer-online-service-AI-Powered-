import 'dart:convert';
import '../../data/providers/interest.dart';

import 'package:ai_powered_app/screen/matrimony.screen/education.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/profileGetDataProvider.dart';

class InterestPage extends ConsumerStatefulWidget {
  const InterestPage({super.key});

  @override
  ConsumerState<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends ConsumerState<InterestPage> {
  Set<String> selectedInterests = {};
  final List<String> interestList = [
    "Music",
    "Reading",
    "Cricket",
    "Art",
    "Test",
    "Technology",
    "Science",
    "Literature",
    "Travel",
    "Food",
    "Fashion",
    "Health",
    "Fitness",
    "Photography",
    "Gaming",
    "Nature",
    "History",
    "Education",
    "Finance",
    "Sports",
    "Theater",
    "Crafts",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final profileData = ref
        .read(profileDataProvider)
        .maybeWhen(data: (data) => data, orElse: () => null);

    if (profileData != null && selectedInterests.isEmpty) {
      final existing =
          profileData.data.profile.interest; // Example: "Music, Travel, Food"

      if (existing != null && existing.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(existing);
          final parsed =
              decoded
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
              children:
                  interestList.map((interest) {
                    final isSelected = selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(
                        interest,
                        style: GoogleFonts.gothicA1(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: isSelected ? Colors.white : Color(0xFF030016),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: Color(0xFF97144d),
                      backgroundColor: Color(0xFFF2D4DC),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedInterests.add(interest);
                          } else {
                            selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),

            SizedBox(height: 30.h),

            /// Continue Button
            GestureDetector(
              onTap: () {
                if (selectedInterests.isEmpty) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please select at least one interest before continuing.",
                        style: GoogleFonts.gothicA1(),
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return; // Prevent navigation
                }
                final interestJsonString =
                    jsonEncode(selectedInterests.toList()) + "\n";
                ref.read(selectedInterestProvider.notifier).state =
                    interestJsonString;

                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => EducationPage()),
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
