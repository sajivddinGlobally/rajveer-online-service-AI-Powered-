/*



import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetFamilyPage.dart';
import 'package:ai_powered_app/screen/matrimony.screen/family.details.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final companyNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final annualIncomeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final qualificationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final professionControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());


final isIncomePrivateProvider = StateProvider<bool>((ref) => false);

class profileGetEducation extends ConsumerStatefulWidget {
  const profileGetEducation({super.key});

  @override
  ConsumerState<profileGetEducation> createState() => _profileGetEducationState();
}

class _profileGetEducationState extends ConsumerState<profileGetEducation> {


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
        final qualification = ref.read(annualIncomeControllerProvider);
        final profession = ref.read(annualIncomeControllerProvider);


        if (companyCtrl.text.isEmpty) companyCtrl.text = profile.company ?? '';
        if (incomeCtrl.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';
        if (qualification.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';
        if (profession.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';

        bool isIncomePrivate;
        if (profile.incomePrivate is bool) {
          isIncomePrivate = profile.incomePrivate;
        } else if (profile.incomePrivate is String) {
          isIncomePrivate = profile.incomePrivate.toLowerCase() == 'true' ||
              profile.incomePrivate == '1';
        } else {
          isIncomePrivate = false; // Fallback for null or unexpected types
        }
        ref.read(isIncomePrivateProvider.notifier).state = isIncomePrivate;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualification =ref.watch(qualificationControllerProvider);
    final profession =ref.watch(professionControllerProvider);
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
                // BuildDropDown(
                //   hint: "Select Highest Qualification",
                //   items: qualificationList,
                //   value: qualification,
                //   onChange: (value) => ref.read(qualificationProvider.notifier).state = value,
                // ),
                _buildLabel("Highest Qualification"),
                TextField(
                  enabled: false,
                  controller: qualification,
                  decoration: _inputDecoration("Enter your Highest Qualification"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Profession"),
                TextField(
                  enabled: false,
                  controller: profession,
                  decoration: _inputDecoration("Enter your Profession"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Organization Name"),
                TextField(
                  enabled: false,
                  controller: companyController,
                  decoration: _inputDecoration("Enter Company / Organization Name"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Annual Income"),
                TextField(
                  enabled: false,
                   keyboardType: TextInputType.number,
                        inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  // या इससे भी आसान और आम तरीका:
  FilteringTextInputFormatter.digitsOnly,
],
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
                        onChanged: null, // Disable manual toggling
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
                      CupertinoPageRoute(builder: (_) => const profileGetFamilyPage()),
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




import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetFamilyPage.dart';
import 'package:ai_powered_app/screen/matrimony.screen/family.details.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'basicDetail.dart';

final companyNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final annualIncomeControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final qualificationControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final professionControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

final isIncomePrivateProvider = StateProvider<bool>((ref) => false);

class profileGetEducation extends ConsumerStatefulWidget {
  const profileGetEducation({super.key});

  @override
  ConsumerState<profileGetEducation> createState() => _profileGetEducationState();
}

class _profileGetEducationState extends ConsumerState<profileGetEducation> {
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
        final qualificationCtrl = ref.read(qualificationControllerProvider);
        final professionCtrl = ref.read(professionControllerProvider);

        if (companyCtrl.text.isEmpty) companyCtrl.text = profile.company ?? '';
        if (incomeCtrl.text.isEmpty) incomeCtrl.text = profile.annualIncome ?? '';
        if (qualificationCtrl.text.isEmpty) qualificationCtrl.text = profile.qualification ?? '';
        // if (professionCtrl.text.isEmpty) professionCtrl.text = profile.pr ?? '';

        bool isIncomePrivate;
        if (profile.incomePrivate is bool) {
          isIncomePrivate = profile.incomePrivate;
        } else if (profile.incomePrivate is String) {
          isIncomePrivate = profile.incomePrivate.toLowerCase() == 'true' || profile.incomePrivate == '1';
        } else {
          isIncomePrivate = false;
        }
        ref.read(isIncomePrivateProvider.notifier).state = isIncomePrivate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualification = ref.watch(qualificationControllerProvider);
    final profession = ref.watch(professionControllerProvider);
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
        data: (profile) {
          // Check if any field has valid data
          final hasData = (
              profile.data.profile.qualification != null
                  && profile.data.profile.qualification!.isNotEmpty
          ) ||
              // (profile.data.profile.profession != null && profile.data.profile.profession!.isNotEmpty) ||
              (profile.data.profile.company != null && profile.data.profile.company!.isNotEmpty) ||
              (profile.data.profile.annualIncome != null && profile.data.profile.annualIncome!.isNotEmpty) ||
              (profile.data.profile.incomePrivate != null);

          return Padding(
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
                  // Conditionally display fields only if API data is present
                  if (profile.data.profile.qualification != null && profile.data.profile.qualification!.isNotEmpty) ...[
                    _buildLabel("Highest Qualification"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                      controller: qualification,
                      decoration: _inputDecoration("Enter your Highest Qualification"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  // if (profile.data.profile.profession != null && profile.data.profile.profession!.isNotEmpty) ...[
                  //   _buildLabel("Profession"),
                  //   SizedBox(height: 15.h),
                  //   TextField(
                  //     enabled: false,
                  //     controller: profession,
                  //     decoration: _inputDecoration("Enter your Profession"),
                  //   ),
                  //   SizedBox(height: 15.h),
                  // ],
                  if (profile.data.profile.company != null && profile.data.profile.company!.isNotEmpty) ...[
                    _buildLabel("Organization Name"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                      controller: companyController,
                      decoration: _inputDecoration("Enter Company / Organization Name"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.annualIncome != null && profile.data.profile.annualIncome!.isNotEmpty) ...[
                    _buildLabel("Annual Income"),
                    SizedBox(height: 15.h),
                    TextField(
                      enabled: false,
                       keyboardType: TextInputType.number,

                      controller: incomeController,
                      decoration: _inputDecoration("Enter Annual Income"),
                    ),
                    SizedBox(height: 15.h),
                  ],
                  if (profile.data.profile.incomePrivate != null) ...[
                    Row(
                      children: [
                        SizedBox(
                          width: 25.w,
                          height: 25.w,
                          child: Checkbox(
                            activeColor: const Color(0xFF97144d),
                            value: isChecked,
                            onChanged: null,
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
                  ],
                  // Show "Continue" button only if at least one field has data
                  if (hasData) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => const profileGetFamilyPage()),
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