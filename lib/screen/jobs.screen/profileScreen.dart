// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
//
// import '../../data/models/jobApplicationModel.dart';
// import '../../data/providers/jobResisterEmployer.dart';
// import '../../data/providers/myJob.dart';
// import '../matrimony.screen/start.page.dart';
// import 'education.screen.dart';
//
// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({super.key});
//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//
//   final nameController = TextEditingController();
//   final numberController = TextEditingController();
//   final emailCotnroller = TextEditingController();
//   final exprieneController = TextEditingController();
//   final locationController = TextEditingController();
//   String? gender;
//   final List<String> genderList = ["Male", "Female", "Other"];
//
//   bool isLoading = false;
//   // ... other existing variables ...
//   String? userId; // Make nullable since we'll load it asynchronously
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//   }
//
//   Future<void> _loadUserId() async {
//     final box = await Hive.openBox('userdata');
//     setState(() {
//       userId = box.get('userName');
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final jobApplicationsAsync = ref.watch(myJobsBasedProvider);
//
//     return Scaffold(
//         backgroundColor: const Color(0xFFF5F8FA),
//         body:
//
//         Column(children: [
//           SizedBox(height: 60.h),
//           Row(
//             children: [
//               SizedBox(width: 24.w),
//               Container(
//                 width: 40.w,
//                 height: 40.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   color: const Color(0xFF0A66C2),
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     "assets/rajveer.png",
//                     color: const Color(0xFFFFFFFF),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Job Portal",
//                     style: GoogleFonts.alexandria(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF030016),
//
//                     ),
//                   ),
//                   Text(
//                     '$userId',
//                     style: GoogleFonts.alexandria(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF9A97AE),
//
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () async {
//                   final box = await Hive.openBox('userdata');
//                   await box.clear(); // Clear saved user data
//                   if (context.mounted) {
//                     Navigator.pushReplacement(
//                       context,
//                       CupertinoPageRoute(builder: (_) => const StartPage()),
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: 103.w,
//                   height: 53.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.r),
//                     color: Color(0xFF0A66C2),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Logout",
//                       style: GoogleFonts.gothicA1(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 24.w),
//             ],
//           ),
//
//
//
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Basic Information",
//                     style: GoogleFonts.alexandria(
//                       fontSize: 30.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF030016),
//
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFieldBody(
//                     controller: nameController,
//                     hint: "Enter your full name",
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFieldBody(
//                     controller: nameController,
//                     hint: "Enter your number",
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFieldBody(
//                     controller: nameController,
//                     hint: "Enter your email",
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFieldBody(
//                     controller: exprieneController,
//                     hint: "Enter your Years of Experience",
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFieldBody(
//                     controller: locationController,
//                     hint: "Enter your Current Location",
//                   ),
//
//                   SizedBox(height: 15.h),
//                   DropdownButtonFormField<String>(
//                     //value: gender,
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.r),
//                         borderSide: BorderSide(
//                           color: Color(0xFFDADADA),
//                           width: 1.5.w,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15.r),
//                         borderSide: BorderSide(
//                           color: Color(0xFFDADADA),
//                           width: 1.5.w,
//                         ),
//                       ),
//                       hintText: "Select Your Gender",
//                       hintStyle: GoogleFonts.alexandria(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF9A97AE),
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                     items:
//                     genderList.map((data) {
//                       return DropdownMenuItem(
//                         value: data,
//                         child: Text(
//                           data,
//                           style: GoogleFonts.gothicA1(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xFF030016),
//                             letterSpacing: -0.2,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         gender = value;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 25.h),
//                   GestureDetector(
//                     // onTap: () {
//                     //
//                     //
//                     //
//                     //
//                     //   // Navigator.push(
//                     //   //   context,
//                     //   //   CupertinoPageRoute(builder: (context) => EducationScreen()),
//                     //   // );
//                     // },
//
//                     onTap: () async {
//
//
//                       final box = await Hive.openBox('userdata');
//                       final userId = box.get('user_id');
//
//
//
//                       setState(() => isLoading = true);
//                       //
//                       // try {
//                       //   await ref.read(jobResisterEmployerProvider({
//                       //     "company_name": "job!.id",
//                       //     "email": userId,
//                       //     "password": "I'm interested in this position",
//                       //     "contact_person": "I'm interested in this position",
//                       //     "phone": "I'm interested in this position",
//                       //   }).future);
//                       //
//                       //   Fluttertoast.showToast(msg: "Application submitted!");
//                       //   Navigator.pop(context);
//                       // } catch (e) {
//                       //   Fluttertoast.showToast(msg: "Failed to apply: ${e.toString()}");
//                       // } finally {
//                       //   setState(() => isLoading = false);
//                       // }
//                     },
//                     child: Container(
//                       width: 392.w,
//                       height: 53.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15.r),
//                         color: Color(0xFF0A66C2),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Submit",
//                           style: GoogleFonts.alexandria(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             )
//           ),
//         ],)
//
//
//     );
//   }
//
// }
//
//
//
// class TextFieldBody extends StatelessWidget {
//   final String hint;
//   final TextEditingController controller;
//   const TextFieldBody({
//     super.key,
//     required this.hint,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
//         ),
//         hintText: hint,
//         hintStyle: GoogleFonts.alexandria(
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF9A97AE),
//           letterSpacing: -0.2,
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import '../../core/auth/login.auth.dart';
// import '../../data/providers/myJob.dart';
// import '../matrimony.screen/start.page.dart';
//
//
// class ProfileScreen extends ConsumerStatefulWidget {
//   const ProfileScreen({super.key});
//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }
// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//   final phoneController = TextEditingController();
//   final contact_personController = TextEditingController();
//   final passwordCotnroller = TextEditingController();
//   final emailController = TextEditingController();
//   final company_nameController = TextEditingController();
//   String? gender;
//   final List<String> genderList = ["Male", "Female", "Other"];
//   bool isLoading = false;
//   String? userId; // Make nullable since we'll load it asynchronously
//
//   @override
//   void initState() {
//     super.initState();
//     // _loadUserId();
//   }
//   // Future<void> _loadUserId() async {
//   //   final box = await Hive.openBox('userdata');
//   //   setState(() {
//   //     userId = box.get('userName');
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final jobApplicationsAsync = ref.watch(myJobsBasedProvider);
//     return Scaffold(
//         backgroundColor: const Color(0xFFF5F8FA),
//         body:
//             SingleChildScrollView(child:
//         Column(children: [
//           SizedBox(height: 60.h),
//           Row(
//             children: [
//               SizedBox(width: 24.w),
//               Container(
//                 width: 40.w,
//                 height: 40.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   color: const Color(0xFF0A66C2),
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     "assets/rajveer.png",
//                     color: const Color(0xFFFFFFFF),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Job Portal",
//                     style: GoogleFonts.alexandria(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF030016),
//
//                     ),
//                   ),
//                   Text(
//                     '$userId',
//                     style: GoogleFonts.alexandria(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF9A97AE),
//
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () async {
//                   final box = await Hive.openBox('userdata');
//                   await box.clear(); // Clear saved user data
//                   if (context.mounted) {
//                     Navigator.pushReplacement(
//                       context,
//                       CupertinoPageRoute(builder: (_) => const StartPage()),
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: 103.w,
//                   height: 53.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.r),
//                     color: Color(0xFF0A66C2),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Logout",
//                       style: GoogleFonts.gothicA1(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 24.w),
//             ],
//           ),
//
//
//
//           SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Basic Information",
//                       style: GoogleFonts.alexandria(
//                         fontSize: 30.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF030016),
//
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     TextFieldBody(
//                       controller: contact_personController,
//                       hint: "Enter Contact Person",
//                     ),
//                     SizedBox(height: 20.h),
//                     TextFieldBody(
//                       controller: phoneController,
//                       hint: "Enter your mobile number",
//                     ),
//                     SizedBox(height: 20.h),
//                     TextFieldBody(
//                       controller: emailController,
//                       hint: "Enter your email",
//                     ),
//                     SizedBox(height: 20.h),
//                     TextFieldBody(
//                       controller: passwordCotnroller,
//                       hint: "Enter Your Password",
//                     ),
//                     SizedBox(height: 20.h),
//                     TextFieldBody(
//                       controller: company_nameController,
//                       hint: "Enter Company Name",
//                     ),
//
//                     SizedBox(height: 15.h),
//
//                     SizedBox(height: 25.h),
//                     // GestureDetector(
//                     //
//                     //   onTap: () async {
//                     //     final box = await Hive.openBox('userdata');
//                     //     setState(() => isLoading = true);
//                     //     await Auth.resisterEmployerRequestBody(
//                     //       contact_personController.text,
//                     //       emailController.text,
//                     //       passwordCotnroller.text,
//                     //       company_nameController.text,
//                     //       phoneController.text,
//                     //       context,
//                     //     );
//                     //   },
//                     //   child: Container(
//                     //     width: 392.w,
//                     //     height: 53.h,
//                     //     decoration: BoxDecoration(
//                     //       borderRadius: BorderRadius.circular(15.r),
//                     //       color: Color(0xFF0A66C2),
//                     //     ),
//                     //     child: Center(
//                     //       child: Text(
//                     //         "Submit",
//                     //         style: GoogleFonts.alexandria(
//                     //           fontSize: 18.sp,
//                     //           fontWeight: FontWeight.w500,
//                     //           color: Colors.white,
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//
//
//
//                     GestureDetector(
//                       onTap: () async {
//                         setState(() => isLoading = true);
//                         try {
//                           await Auth.resisterEmployerRequestBody(
//                             contact_personController.text,
//                             emailController.text,
//                             passwordCotnroller.text,
//                             company_nameController.text,
//                             phoneController.text,
//                             context,
//                           );
//                         } catch (e) {
//                           print("Error: $e");
//                         } finally {
//                           setState(() => isLoading = false);
//                         }
//                       },
//                       child: Container(
//                         width: 392.w,
//                         height: 53.h,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.r),
//                           color: const Color(0xFF0A66C2),
//                         ),
//                         child: Center(
//                           child: isLoading
//                               ? const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                               : Text(
//                             "Submit",
//                             style: GoogleFonts.alexandria(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 20.h),
//                   ],
//                 ),
//               )
//           ),
//         ],)
//
//             )
//     );
//   }
//
// }
//
//
//
// class TextFieldBody extends StatelessWidget {
//   final String hint;
//   final TextEditingController controller;
//   const TextFieldBody({
//     super.key,
//     required this.hint,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15.r),
//           borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
//         ),
//         hintText: hint,
//         hintStyle: GoogleFonts.alexandria(
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF9A97AE),
//           letterSpacing: -0.2,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../core/auth/login.auth.dart';
import '../../data/providers/myJob.dart';
import '../start.page.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final phoneController = TextEditingController();
  final contact_personController = TextEditingController();
  final passwordCotnroller = TextEditingController();
  final emailController = TextEditingController();
  final company_nameController = TextEditingController();
  String? gender;
  final List<String> genderList = ["Male", "Female", "Other"];
  bool isLoading = false;
  String? userId; // Make nullable since we'll load it asynchronously

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final box = await Hive.openBox('userdata');
    setState(() {
      userId = box.get('userName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Row(
              children: [
                SizedBox(width: 24.w),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFF0A66C2),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/rajveer.png",
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Job Portal",
                      style: GoogleFonts.alexandria(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    Text(
                      '$userId',
                      style: GoogleFonts.alexandria(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9A97AE),
                      ),
                    ),
                  ],
                ),

                //const Spacer(),
                //SizedBox(width: 24.w),
              ],
            ),

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Information",
                      style: GoogleFonts.alexandria(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF030016),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextFieldBody(
                      keyboardType: TextInputType.text,
                      controller: contact_personController,
                      hint: "Enter Your Name",
                    ),
                    SizedBox(height: 20.h),
                    TextFieldBody(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      hint: "Enter your mobile number",
                    ),
                    SizedBox(height: 20.h),
                    TextFieldBody(
                      keyboardType: TextInputType.text,
                      controller: emailController,
                      hint: "Enter your email",
                    ),
                    SizedBox(height: 20.h),
                    TextFieldBody(
                      keyboardType: TextInputType.text,
                      controller: passwordCotnroller,
                      hint: "Enter Your Password",
                    ),
                    SizedBox(height: 20.h),
                    TextFieldBody(
                      keyboardType: TextInputType.text,
                      controller: company_nameController,
                      hint: "Enter Company Name",
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(height: 25.h),

                    GestureDetector(
                      onTap: () async {
                        if (contact_personController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordCotnroller.text.isEmpty ||
                            company_nameController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all the fields'),
                            ),
                          );
                          return;
                        }
                        setState(() => isLoading = true);
                        try {
                          await Auth.resisterEmployerRequestBody(
                            contact_personController.text,
                            emailController.text,
                            passwordCotnroller.text,
                            company_nameController.text,
                            phoneController.text,
                            context,
                          );
                        } catch (e) {
                          print("Error: $e");
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                      child: Container(
                        width: 392.w,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: const Color(0xFF0A66C2),
                        ),
                        child: Center(
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    "Submit",
                                    style: GoogleFonts.alexandria(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldBody extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;

  const TextFieldBody({
    super.key,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    this.maxLength,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        counterText: '', // hide character counter

        contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5.w),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.alexandria(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
