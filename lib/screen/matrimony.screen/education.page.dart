/*
import 'package:ai_powered_app/screen/matrimony.screen/family.details.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final qualificationProvider = StateProvider<String?>((ref) => null);
final professionProvider = StateProvider<String?>((ref) => null);
final companyNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final annualIncomeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final isIncomePrivateProvider = StateProvider<bool>((ref) => false);

class EducationPage extends ConsumerStatefulWidget {
  const EducationPage({super.key});

  @override
  ConsumerState<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends ConsumerState<EducationPage> {
  final List<String> qualificationList = [
    "High School",
    "Intermediate",
    "Diploma",
    "Bachelor's Degree",
    "Master's Degree",
    "PhD",
  ];

  final List<String> professionList = [
    "Government Job",
    "Private Job",
    "Business",
    "Self-Employed",
    "Doctor",
    "Engineer",
    "Teacher",
    "Professor",
    "Chartered Accountant",
    "Banker",
    "Lawyer",
    "Software Developer",
    "Architect",
    "Marketing Executive",
    "Sales Manager",
    "HR Professional",
    "Police/Defence",
    "Journalist",
    "Scientist",
    "Actor/Model",
    "Freelancer",
    "Not Working",
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
        final companyCtrl = ref.read(companyNameControllerProvider);
        final incomeCtrl = ref.read(annualIncomeControllerProvider);
        if (companyCtrl.text.isEmpty) companyCtrl.text = profile.company ?? '';
        if (incomeCtrl.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';
        ref.read(qualificationProvider.notifier).state = profile.qualification;
        ref.read(professionProvider.notifier).state = profile.occupation;
        ref.read(isIncomePrivateProvider.notifier).state = profile.incomePrivate ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualification = ref.watch(qualificationProvider);
    final profession = ref.watch(professionProvider);
    final companyController = ref.watch(companyNameControllerProvider);
    final incomeController = ref.watch(annualIncomeControllerProvider);
    final isChecked = ref.watch(isIncomePrivateProvider);
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F8),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const FamilyDetailsPage()),
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
          child:
          SingleChildScrollView(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Education & Career",
                style: GoogleFonts.gothicA1(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF030016),
                  
                ),
              ),
              Text(
                "Tell Us About Your Career",
                style: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9A97AE),
                ),
              ),
              SizedBox(height: 20.h),
              buildDropDown(
                hint: "Select Highest Qualification",
                items: qualificationList,
                value: qualification,
                onChange: (value) => ref.read(qualificationProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),
              buildDropDown(
                hint: "Select Profession",
                items: professionList,
                value: profession,
                onChange: (value) => ref.read(professionProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),
              TextField(
                controller: companyController,
                decoration: _inputDecoration("Enter Company / Organization Name"),
              ),
              SizedBox(height: 15.h),
              TextField(
                controller: incomeController,
                decoration: _inputDecoration("Enter Annual Income"),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  SizedBox(
                    width: 25.w,
                    height: 25.w,
                    child: Checkbox(
                      activeColor: const Color(0xFF97144d),
                      value: isChecked,
                      onChanged: (value) => ref.read(isIncomePrivateProvider.notifier).state = value ?? false,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Make income private",
                    style: GoogleFonts.gothicA1(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF030016),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const FamilyDetailsPage()),
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
    )) ;
  }
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF030016),
        letterSpacing: -0.2,
      ),
    );
  }
}

*/
/*

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
*//*




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

        // Default border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color:hint=="Role"? const Color(0xFF00796B): const Color(0xFF97144d),
            width: 1.5.w,
          ),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color:hint=="Role"? const Color(0xFF00796B): const Color(0xFF97144d),
            width: 1.5.w,
          ),
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


import 'package:ai_powered_app/screen/matrimony.screen/family.details.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final qualificationProvider = StateProvider<String?>((ref) => null);
final professionProvider = StateProvider<String?>((ref) => null);
final companyNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final annualIncomeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final isIncomePrivateProvider = StateProvider<bool>((ref) => false);

class EducationPage extends ConsumerStatefulWidget {
  const EducationPage({super.key});

  @override
  ConsumerState<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends ConsumerState<EducationPage> {
  final List<String> qualificationList = [
    "High School",
    "Intermediate",
    "Diploma",
    "Bachelor's Degree",
    "Master's Degree",
    "PhD",
  ];

  final List<String> professionList = [
    "Government Job",
    "Private Job",
    "Business",
    "Self-Employed",
    "Doctor",
    "Engineer",
    "Teacher",
    "Professor",
    "Chartered Accountant",
    "Banker",
    "Lawyer",
    "Software Developer",
    "Architect",
    "Marketing Executive",
    "Sales Manager",
    "HR Professional",
    "Police/Defence",
    "Journalist",
    "Scientist",
    "Actor/Model",
    "Freelancer",
    "Not Working",
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
        final companyCtrl = ref.read(companyNameControllerProvider);
        final incomeCtrl = ref.read(annualIncomeControllerProvider);
        if (companyCtrl.text.isEmpty) companyCtrl.text = profile.company ?? '';
        if (incomeCtrl.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';
        ref.read(qualificationProvider.notifier).state =
        qualificationList.contains(profile.qualification) ? profile.qualification : null;
        ref.read(professionProvider.notifier).state =
        professionList.contains(profile.occupation) ? profile.occupation : null;
        // ref.read(isIncomePrivateProvider.notifier).state = profile.incomePrivate ?? false;
        ref.read(isIncomePrivateProvider.notifier).state =
        profile.incomePrivate == "1" ? true : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualification = ref.watch(qualificationProvider);
    final profession = ref.watch(professionProvider);
    final companyController = ref.watch(companyNameControllerProvider);
    final incomeController = ref.watch(annualIncomeControllerProvider);
    final isChecked = ref.watch(isIncomePrivateProvider);
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F8),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const FamilyDetailsPage()),
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
                  "Education & Career",
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                Text(
                  "Tell Us About Your Career",
                  style: GoogleFonts.gothicA1(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                  ),
                ),
                SizedBox(height: 20.h),
                BuildDropDown(
                  hint: "Select Highest Qualification",
                  items: qualificationList,
                  value: qualification,
                  onChange: (value) => ref.read(qualificationProvider.notifier).state = value,
                ),
                SizedBox(height: 15.h),
                BuildDropDown(
                  hint: "Select Profession",
                  items: professionList,
                  value: profession,
                  onChange: (value) => ref.read(professionProvider.notifier).state = value,
                ),
                SizedBox(height: 15.h),
                TextField(
                  controller: companyController,
                  decoration: _inputDecoration("Enter Company / Organization Name"),
                ),
                SizedBox(height: 15.h),
                TextField(
                   keyboardType: TextInputType.number,

                  controller: incomeController,
                  decoration: _inputDecoration("Enter Annual Income"),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                      height: 25.w,
                      child: Checkbox(
                        activeColor: const Color(0xFF97144d),
                        value: isChecked,
                        onChanged: (value) => ref.read(isIncomePrivateProvider.notifier).state = value ?? false,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Make income private",
                      style: GoogleFonts.gothicA1(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {
                    if (qualification == null || profession == null ||companyController.text.isEmpty || incomeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select All Field")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const FamilyDetailsPage()),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: const Color(0xFF97144d), width: 2.w),
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