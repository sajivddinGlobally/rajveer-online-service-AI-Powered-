/*
import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetPhoto.dart';
import 'package:ai_powered_app/screen/start.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../profile.page.dart';



final nameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final dobControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final genderControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final castControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final religionControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);
final maritalControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController(),);

// Utility function to capitalize the first word
String capitalizeFirstWord(String text) {
  if (text.isEmpty) return text;
  List<String> words = text.trim().split(' ');
  if (words.isNotEmpty) {
    words[0] = words[0].isNotEmpty
        ? '${words[0][0].toUpperCase()}${words[0].substring(1).toLowerCase()}'
        : words[0];
    return words.join(' ');
  }
  return text;
}

class BasicDetail extends ConsumerWidget {
  const BasicDetail({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final profileAsync = ref.watch(profileDataProvider);

    final nameController = ref.watch(nameControllerProvider);
    final genderController = ref.watch(genderControllerProvider);
    final religionController = ref.watch(religionControllerProvider);
    final castController = ref.watch(castControllerProvider);
    final maritalController = ref.watch(maritalControllerProvider);
    final dobController = ref.watch(dobControllerProvider);


    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {



          WidgetsBinding.instance.addPostFrameCallback((_) {

            if (nameController.text.isEmpty) {


              nameController.text = profile.data.profile.name ?? '';
              genderController.text = capitalizeFirstWord(profile.data.profile.gender ?? '');
              religionController.text = profile.data.profile.religion ?? '';
              castController.text = profile.data.profile.caste ?? '';
              maritalController.text = profile.data.profile.maritalStatus ?? '';
              dobController.text = profile.data.profile.dateOfBirth.toString().split(" ")[0];


            }

          });



          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Details",
                      style: GoogleFonts.gothicA1(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    Text(
                      "Let's Start with the Basics",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9A97AE),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        final box = await Hive.openBox('userdata');
                        await box.clear(); // Clear saved user data
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const StartPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 103.w,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xFF97144d),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: GoogleFonts.gothicA1(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );

                      },
                      child: Container(
                        width: 113.w,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xFF97144d),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Profile",
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
                SizedBox(height: 26.h),
                _buildLabel("Full Name"),
                SizedBox(height: 10.h),
                TextField( 
                  enabled: false,
                  controller: nameController,
                  decoration: _inputDecoration("Enter your full name"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Select Gender"),
                SizedBox(height: 10.h),

                TextField(
                  enabled: false,
                  controller: genderController,
                  decoration: _inputDecoration("Enter your Gender"),
                ),


                SizedBox(height: 15.h),

                _buildLabel("Date of Birth"),

                SizedBox(height: 10.h),

                TextField(
                  enabled: false,
                  controller: dobController,
                  decoration: _inputDecoration("Enter your Date of Birt"),
                ),

                SizedBox(height: 15.h),

                _buildLabel("Select Religion"),
                SizedBox(height: 10.h),
                TextField(
                  enabled: false,
                  controller: religionController,
                  decoration: _inputDecoration("Enter your religion"),
                ),


                SizedBox(height: 15.h),
                _buildLabel("Select Caste"),
                SizedBox(height: 10.h),
                TextField(
                  enabled: false,
                  controller: castController,
                  decoration: _inputDecoration("Enter your Cast"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Marital Status"),
                SizedBox(height: 10.h),

                TextField(
                  enabled: false,
                  controller: maritalController,
                  decoration: _inputDecoration("Enter your Marital Status"),
                ),

                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>  ProfileGetPhoto(),
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


  Widget buildDatePickerField(
      BuildContext context,
      TextEditingController controller,
      String hint,
      ) {
    return TextField(
      controller: controller,
      readOnly: true, // Prevent manual typing
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        suffixIcon: const Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFF97144d), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFF97144d), width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFF97144d)),
        ),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          final formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
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
}*/



import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetPhoto.dart';
import 'package:ai_powered_app/screen/start.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../profile.page.dart';

final nameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final dobControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final genderControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final castControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final religionControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final maritalControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

// Utility function to capitalize the first word
String capitalizeFirstWord(String text) {
  if (text.isEmpty) return text;
  List<String> words = text.trim().split(' ');
  if (words.isNotEmpty) {
    words[0] = words[0].isNotEmpty
        ? '${words[0][0].toUpperCase()}${words[0].substring(1).toLowerCase()}'
        : words[0];
    return words.join(' ');
  }
  return text;
}

class BasicDetail extends ConsumerWidget {
  const BasicDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final nameController = ref.watch(nameControllerProvider);
    final genderController = ref.watch(genderControllerProvider);
    final religionController = ref.watch(religionControllerProvider);
    final castController = ref.watch(castControllerProvider);
    final maritalController = ref.watch(maritalControllerProvider);
    final dobController = ref.watch(dobControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      // appBar: AppBar(
      //     leading: null,
      //     backgroundColor: const Color(0xFFFDF6F8)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (nameController.text.isEmpty) {
              nameController.text = profile.data.profile.name ?? '';
              genderController.text = capitalizeFirstWord(profile.data.profile.gender ?? '');
              religionController.text = profile.data.profile.religion ?? '';
              castController.text = profile.data.profile.caste ?? '';
              maritalController.text = profile.data.profile.maritalStatus ?? '';
              dobController.text = profile.data.profile.dateOfBirth.toString().split(" ")[0];
            }
          });

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final box = await Hive.openBox('userdata');
                        await box.clear();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const StartPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 103.w,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xFF97144d),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
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


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Details",
                      style: GoogleFonts.gothicA1(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    Text(
                      "Let's Start with the Basics",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9A97AE),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 113.w,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xFF97144d),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Profile",
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
                SizedBox(height: 26.h),
                // Conditionally display fields only if API data is present
                if (profile.data.profile.name != null && profile.data.profile.name!.isNotEmpty) ...[
                  _buildLabel("Full Name"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: nameController,
                    decoration: _inputDecoration("Enter your full name"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.gender != null && profile.data.profile.gender!.isNotEmpty) ...[
                  _buildLabel("Select Gender"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: genderController,
                    decoration: _inputDecoration("Enter your Gender"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.dateOfBirth != null) ...[
                  _buildLabel("Date of Birth"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: dobController,
                    decoration: _inputDecoration("Enter your Date of Birth"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.religion != null && profile.data.profile.religion!.isNotEmpty) ...[
                  _buildLabel("Religion"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: religionController,
                    decoration: _inputDecoration("Enter your religion"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.caste != null && profile.data.profile.caste!.isNotEmpty) ...[
                  _buildLabel("Caste"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: castController,
                    decoration: _inputDecoration("Enter your Caste"),
                  ),
                  SizedBox(height: 15.h),
                ],
                if (profile.data.profile.maritalStatus != null && profile.data.profile.maritalStatus!.isNotEmpty) ...[
                  _buildLabel("Marital Status"),
                  SizedBox(height: 10.h),
                  TextField(
                    enabled: false,
                    controller: maritalController,
                    decoration: _inputDecoration("Enter your Marital Status"),
                  ),
                  SizedBox(height: 15.h),
                ],
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {

                    if (
                    profile.data.profile.maritalStatus != null && profile.data.profile.maritalStatus!.isNotEmpty
                  &&  profile.data.profile.gender != null && profile.data.profile.gender!.isNotEmpty
                    && profile.data.profile.dateOfBirth != null
                    &&
                        profile.data.profile.religion != null && profile.data.profile.religion!.isNotEmpty
                    &&
                        profile.data.profile.caste != null && profile.data.profile.caste!.isNotEmpty
                    &&
                        profile.data.profile.dateOfBirth != null
                    ) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => ProfileGetPhoto(),
                        ),
                      );
                    }else{

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please Update Your Profile",
                            style: GoogleFonts.gothicA1(),
                          ),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
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