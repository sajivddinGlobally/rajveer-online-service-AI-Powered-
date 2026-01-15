/*



import 'package:ai_powered_app/screen/matrimony.screen/partner.preference.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final fatherOccupationProvider = StateProvider<String?>((ref) => null);
final motherOccupationProvider = StateProvider<String?>((ref) => null);
final familyTypeProvider = StateProvider<String?>((ref) => null);
class FamilyDetailsPage extends ConsumerStatefulWidget {
  const FamilyDetailsPage({super.key});

  @override
  ConsumerState<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends ConsumerState<FamilyDetailsPage> {
  final List<String> fatherOccupationList = [
    "Government Job", "Private Job", "Business", "Self-Employed", "Farmer",
    "Doctor", "Engineer", "Teacher", "Retired", "Defence Personnel",
    "Lawyer", "Not Alive", "Other",
  ];

  final List<String> motherOccupationList = [
    "Homemaker", "Government Job", "Private Job", "Business", "Self-Employed",
    "Teacher", "Doctor", "Retired", "Not Alive", "Other",
  ];

  final List<String> familyTypeList = [
    "Joint Family", "Nuclear Family",  "Extended Family", "Others",
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
        ref.read(fatherOccupationProvider.notifier).state = profile.fatherOccupation;
        ref.read(motherOccupationProvider.notifier).state = profile.motherOccupation;
        ref.read(familyTypeProvider.notifier).state = profile.familyType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);
    final fatherOccupation = ref.watch(fatherOccupationProvider);
    final motherOccupation = ref.watch(motherOccupationProvider);
    final familyType = ref.watch(familyTypeProvider);

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
              buildDropDown(
                hint: "Select Father’s Occupation",
                items: fatherOccupationList,
                value: fatherOccupation,
                onChange: (value) => ref.read(fatherOccupationProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),
              buildDropDown(
                hint: "Select Mother’s Occupation",
                items: motherOccupationList,
                value: motherOccupation,
                onChange: (value) => ref.read(motherOccupationProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),
              buildDropDown(
                hint: "Select Family Type",
                items: familyTypeList,
                value: familyType,
                onChange: (value) => ref.read(familyTypeProvider.notifier).state = value,
              ),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const PartnerPreferencePage()),
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
    );
  }
}

class buildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;

  const buildDropDown({
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
      value: (value != null && items.contains(value)) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.gothicA1(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF030016),
          letterSpacing: -0.2,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
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
      onChanged: onChange,
    );
  }
}
*/



import 'package:ai_powered_app/screen/matrimony.screen/partner.preference.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final fatherOccupationProvider = StateProvider<String?>((ref) => null);
final motherOccupationProvider = StateProvider<String?>((ref) => null);
final familyTypeProvider = StateProvider<String?>((ref) => null);

class FamilyDetailsPage extends ConsumerStatefulWidget {
  const FamilyDetailsPage({super.key});

  @override
  ConsumerState<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends ConsumerState<FamilyDetailsPage> {
  final List<String> fatherOccupationList = [
    "Government Job",
    "Private Job",
    "Business",
    "Self-Employed",
    "Farmer",
    "Doctor",
    "Engineer",
    "Teacher",
    "Retired",
    "Defence Personnel",
    "Lawyer",
    "Not Alive",
    "Other",
  ];

  final List<String> motherOccupationList = [
    "Homemaker",
    "Government Job",
    "Private Job",
    "Business",
    "Self-Employed",
    "Teacher",
    "Doctor",
    "Retired",
    "Not Alive",
    "Other",
  ];

  final List<String> familyTypeList = [
    "Joint Family",
    "Nuclear Family",
    "Extended Family",
    "Others",
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
        ref.read(fatherOccupationProvider.notifier).state =
        fatherOccupationList.contains(profile.fatherOccupation)
            ? profile.fatherOccupation
            : null;
        ref.read(motherOccupationProvider.notifier).state =
        motherOccupationList.contains(profile.motherOccupation)
            ? profile.motherOccupation
            : null;
        ref.read(familyTypeProvider.notifier).state =
        familyTypeList.contains(profile.familyType) ? profile.familyType : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);
    final fatherOccupation = ref.watch(fatherOccupationProvider);
    final motherOccupation = ref.watch(motherOccupationProvider);
    final familyType = ref.watch(familyTypeProvider);

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
                BuildDropDown(
                  hint: "Select Father's Occupation",
                  items: fatherOccupationList,
                  value: fatherOccupation,
                  onChange: (value) => ref.read(fatherOccupationProvider.notifier).state = value,
                ),
                SizedBox(height: 15.h),
                BuildDropDown(
                  hint: "Select Mother's Occupation",
                  items: motherOccupationList,
                  value: motherOccupation,
                  onChange: (value) => ref.read(motherOccupationProvider.notifier).state = value,
                ),
                SizedBox(height: 15.h),
                BuildDropDown(
                  hint: "Select Family Type",
                  items: familyTypeList,
                  value: familyType,
                  onChange: (value) => ref.read(familyTypeProvider.notifier).state = value,
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
                      CupertinoPageRoute(builder: (_) => const PartnerPreferencePage()),
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