

import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:ai_powered_app/screen/matrimony.screen/profile.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/interest.dart';
import '../../data/providers/updateProfileProvider.dart';
import 'education.page.dart';
import 'family.details.page.dart';
import 'home.page.dart';
import 'location.lifeStyle.page.dart';

final partnerAgeRangeProvider = StateProvider<String?>((ref) => null);
final partnerHeightRangeProvider = StateProvider<String?>((ref) => null);
final partnerEducationProvider = StateProvider<String?>((ref) => null);
final partnerLocationProvider = StateProvider<String?>((ref) => null);

final partnerNotesControllerProvider =
Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

class PartnerPreferencePage extends ConsumerStatefulWidget {
  const PartnerPreferencePage({super.key});

  @override
  ConsumerState<PartnerPreferencePage> createState() => _PartnerPreferencePageState();
}

class _PartnerPreferencePageState extends ConsumerState<PartnerPreferencePage> {
  final List<String> ageRangeList = [
    "18 - 22",
    "23 - 27",
    "28 - 32",
    "33 - 37",
    "38 - 42",
    "43 - 47",
    "48 - 52",
    "53+",
  ];

  final List<String> heightRangeList = [
    "4'5\" - 4'8\"",
    "4'9\" - 5'0\"",
    "5'1\" - 5'4\"",
    "5'5\" - 5'8\"",
    "5'9\" - 6'0\"",
    "6'1\" - 6'4\"",
    "6'5\" +",
  ];

  final List<String> educationPreferenceList = [
    "High School",
    "Diploma",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctorate / PhD",
    "Engineering",
    "Medical",
    "Management",
    "Commerce",
    "Arts",
    "Science",
    "Any",
  ];

  final List<String> locationPreferenceList = [
    "Same City",
    "Same State",
    "Anywhere in India",
    "Outside India",
    "Gulf Countries",
    "USA / Canada",
    "Europe",
    "No Preference",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileDataProvider).maybeWhen(
        data: (profile) => profile.data.profile,
        orElse: () => null,
      );
      if (profile != null) {
        ref.read(partnerAgeRangeProvider.notifier).state =
        ageRangeList.contains(profile.partnerAgeRange) ? profile.partnerAgeRange : null;
        ref.read(partnerHeightRangeProvider.notifier).state =
        heightRangeList.contains(profile.partnerHeightRange) ? profile.partnerHeightRange : null;
        ref.read(partnerEducationProvider.notifier).state =
        educationPreferenceList.contains(profile.partnerEducation)
            ? profile.partnerEducation
            : null;
        ref.read(partnerLocationProvider.notifier).state =
        locationPreferenceList.contains(profile.partnerLocation)
            ? profile.partnerLocation
            : null;

        ref.read(partnerNotesControllerProvider).text = profile.partnerNote ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final religion = ref.watch(religionProvider);
    final interest = ref.watch(selectedInterestProvider);
    final ageRange = ref.watch(partnerAgeRangeProvider);
    final heightRange = ref.watch(partnerHeightRangeProvider);
    final educationPref = ref.watch(partnerEducationProvider);
    final locationPref = ref.watch(partnerLocationProvider);
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
            BuildDropDown(
              hint: "Select Age Range",
              items: ageRangeList,
              value: ageRange,
              onChange: (value) => ref.read(partnerAgeRangeProvider.notifier).state = value,
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Height Range",
              items: heightRangeList,
              value: heightRange,
              onChange: (value) => ref.read(partnerHeightRangeProvider.notifier).state = value,
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Education Preference",
              items: educationPreferenceList,
              value: educationPref,
              onChange: (value) => ref.read(partnerEducationProvider.notifier).state = value,
            ),
            SizedBox(height: 15.h),
            BuildDropDown(
              hint: "Select Location Preference",
              items: locationPreferenceList,
              value: locationPref,
              onChange: (value) => ref.read(partnerLocationProvider.notifier).state = value,
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: notesController,
              maxLines: 6,
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
                hintText: "Enter Additional Notes",
                hintStyle: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9A97AE),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () async {
                if (ageRange == null ||
                    heightRange == null ||
                    educationPref == null ||
                    locationPref == null||
                    notesController.text.trim().isEmpty)

                 {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select all required fields")),
                  );
                  return;
                }

                final profileData = {
                  "name": ref.read(nameControllerProvider).text,
                  "date_of_birth": ref.read(dobControllerProvider).text,
                  "gender": ref.read(genderProvider)!.toLowerCase(),
                  "religion": ref.read(religionProvider).toString(),
                  // "caste": ref.read(castProvider).toString(),
                  "caste": religion == "Other"
                      ? ref.read(customCastControllerProvider).text
                      : ref.read(castProvider).toString(),
                  "marital_status": ref.read(maritalProvider).toString(),
                  "qualification": ref.read(qualificationProvider),
                  "occupation": ref.read(professionProvider),
                  "company": ref.read(companyNameControllerProvider).text,
                  "annual_income": ref.read(annualIncomeControllerProvider).text,
                  "income_private": ref.read(isIncomePrivateProvider) ? "1" : "0",
                  "father_occupation": ref.read(fatherOccupationProvider),
                  "mother_occupation": ref.read(motherOccupationProvider),
                  "family_type": ref.read(familyTypeProvider),
                  "partner_age_range": ref.read(partnerAgeRangeProvider),
                  "partner_height_range": ref.read(partnerHeightRangeProvider),
                  "partner_location": ref.read(partnerLocationProvider),
                  "partner_note": ref.read(partnerNotesControllerProvider).text,
                  "interest": interest.toString(),
                  "country": ref.read(countryProvider),
                  "partner_education": ref.read(partnerEducationProvider),
                  "state": ref.read(statelistProvider),
                  "city": ref.read(citylistProvider),
                  "living_status": ref.read(livingStatuslistProvider),
                  "smoke": ref.read(smokinglistProvider),
                  "drink": ref.read(drinkinglistProvider),
                };

                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  // Await the profile update
                  await ref.read(updateProfileProvider(profileData).future);
                  // Invalidate profile provider to force refetch
                  ref.invalidate(profileDataProvider);

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // Close loader
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Update failed: $e")),
                    );
                  }
                }
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
}