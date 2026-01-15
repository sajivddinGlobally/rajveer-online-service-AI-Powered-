import 'package:ai_powered_app/screen/start.page.dart';
import 'package:ai_powered_app/screen/matrimony.screen/upload.photo.page.dart';
import 'package:ai_powered_app/data/providers/profileGetDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

final genderProvider = StateProvider<String?>((ref) => null);
final religionProvider = StateProvider<String?>((ref) => null);
final castProvider = StateProvider<String?>((ref) => null);
final maritalProvider = StateProvider<String?>((ref) => null);
final nameControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final dobControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final customCastControllerProvider =
    Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );

final Map<String, List<String>> religionToCastes = <String, List<String>>{
  "Hindu": [
    "Brahmin",
    "Kshatriya/Rajput",
    "Vaishya/Baniya",
    "Jat",
    "Patel",
    "Yadav",
    "Kori",
    "Kumhar",
    "Kashyap",
    "Khatri",
    "Lohar",
    "Maratha",
    "Sonar",
    "Teli",
    "General",
    "OBC",
    "SC",
    "ST",
    "Other",
  ],
  "Muslim": [
    "Sheikh",
    "Syed",
    "Pathan",
    "Ansari",
    "Qureshi",
    "Memon",
    "Mughal",
    "Other",
  ],
  "Sikh": ["Jatt", "Khatri", "Arora", "Ramgarhia", "Saini", "Other"],
  "Christian": [
    "Catholic",
    "Protestant",
    "Orthodox",
    "Anglican",
    "Pentecostal",
    "Syrian Christian",
    "Other",
  ],
};

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final nameController = ref.watch(nameControllerProvider);
    final dobController = ref.watch(dobControllerProvider);
    final customCastController = ref.watch(customCastControllerProvider);
    final gender = ref.watch(genderProvider);
    final religion = ref.watch(religionProvider);
    final cast = ref.watch(castProvider);
    final marital = ref.watch(maritalProvider);
    final genderList = ["Male", "Female"];
    final religionList = ["Hindu", "Muslim", "Sikh", "Christian", "Other"];
    final List<String> castList =
        religion != null &&
                religion != "Other" &&
                religionToCastes.containsKey(religion)
            ? religionToCastes[religion]!
            : <String>[];

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
              dobController.text =
                  profile.data.profile.dateOfBirth.toString().split(" ")[0];
              ref.read(genderProvider.notifier).state =
                  profile.data.profile.gender.isNotEmpty
                      ? profile.data.profile.gender[0].toUpperCase() +
                          profile.data.profile.gender.substring(1).toLowerCase()
                      : null;
              final profileReligion =
                  religionList.contains(profile.data.profile.religion)
                      ? profile.data.profile.religion
                      : "Other";
              ref.read(religionProvider.notifier).state = profileReligion;
              if (profileReligion == "Other") {
                customCastController.text = profile.data.profile.caste ?? '';
                ref.read(castProvider.notifier).state = null;
              } else if (religionToCastes.containsKey(profileReligion)) {
                final validCastList = religionToCastes[profileReligion]!;
                ref.read(castProvider.notifier).state =
                    validCastList.contains(profile.data.profile.caste)
                        ? profile.data.profile.caste
                        : null;
                customCastController.text = '';
              } else {
                ref.read(castProvider.notifier).state = null;
                customCastController.text = '';
              }
              ref.read(maritalProvider.notifier).state =
                  profile.data.profile.maritalStatus;
            }
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (religion == "Other") {
              ref.read(castProvider.notifier).state = null;
            } else if (cast != null && !castList.contains(cast)) {
              ref.read(castProvider.notifier).state = null;
              customCastController.text = '';
            }
          });

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    GestureDetector(
                      onTap: () async {
                        final box = await Hive.openBox('userdata');
                        await box.clear();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => StartPage(),
                            ),
                            (route) => false,
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
                SizedBox(height: 26.h),
                _buildLabel("Full Name"),
                SizedBox(height: 10.h),
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Enter your full name"),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Select Gender"),
                SizedBox(height: 10.h),
                BuildDropDown(
                  hint: "Select Gender",
                  items: genderList,
                  value: gender,
                  onChange:
                      (value) =>
                          ref.read(genderProvider.notifier).state = value,
                ),
                SizedBox(height: 15.h),
                _buildLabel("Date of Birth"),
                SizedBox(height: 10.h),
                buildDatePickerField(context, dobController, "Date of Birth"),
                SizedBox(height: 15.h),
                _buildLabel("Select Religion"),
                SizedBox(height: 10.h),
                BuildDropDown(
                  hint: "Select Religion",
                  items: religionList,
                  value: religion,
                  onChange: (value) {
                    ref.read(religionProvider.notifier).state = value;
                    ref.read(castProvider.notifier).state = null; // Reset caste
                    customCastController.text = ''; // Reset custom caste
                  },
                ),
                SizedBox(height: 15.h),
                if (religion != "Other")
                  _buildLabel("Select Caste")
                else
                  _buildLabel("Enter Caste"),
                SizedBox(height: 10.h),
                if (religion != "Other")
                  BuildDropDown(
                    hint: "Select Caste",
                    items: castList,
                    value: cast,
                    onChange:
                        (value) =>
                            ref.read(castProvider.notifier).state = value,
                  )
                else
                  TextField(
                    controller: customCastController,
                    decoration: _inputDecoration("Enter your caste"),
                  ),
                SizedBox(height: 15.h),
                _buildLabel("Select Marital Status"),
                SizedBox(height: 10.h),
                BuildDropDown(
                  hint: "Select Marital Status",
                  items: [
                    "Doesn't Matter",
                    "Never Married",
                    "Divorced",
                    "Widowed",
                    "Awaiting Divorce",
                  ],
                  value: marital,
                  onChange:
                      (value) =>
                          ref.read(maritalProvider.notifier).state = value,
                ),
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: () {
                    if (nameController.text.isEmpty ||
                        gender == null ||
                        dobController.text.isEmpty ||
                        religion == null ||
                        (religion == "Other"
                            ? customCastController.text.trim().isEmpty
                            : cast == null) ||
                        marital == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields"),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const UploadPhotoPage(),
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

  Widget buildDatePickerField(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
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
