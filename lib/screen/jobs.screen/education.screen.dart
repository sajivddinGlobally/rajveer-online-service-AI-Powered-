
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../data/models/CreateJobRequest.dart';
import '../../data/providers/employerPost.dart';
import 'home.screen.dart';

class EducationScreen extends ConsumerStatefulWidget {
  final String title;
  final String employment;
  final String location;
  final String requirement;
  final String description;

  const EducationScreen({
    required this.title,
    required this.employment,
    required this.location,
    required this.requirement,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  final minController = TextEditingController();
  final maxController = TextEditingController();
  final salaryMinController = TextEditingController();
  final salaryMaxController = TextEditingController();
  final applicationDeadlineController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    salaryMinController.dispose();
    salaryMaxController.dispose();
    applicationDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F8FA)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              TextFieldBody(controller: minController, hint: "Enter Min Experience",  keyboardType: TextInputType.number,
                      ),

              SizedBox(height: 20.h),

              TextFieldBody(controller: maxController, hint: "EnterMax Experience",  keyboardType: TextInputType.number,
                      ),

              SizedBox(height: 20.h),

              TextFieldBody(controller: salaryMinController, hint: "Enter Salary Min",  keyboardType: TextInputType.number,
                       ),

              SizedBox(height: 20.h),
              TextFieldBody(controller: salaryMaxController, hint: "Enter Salary Max",  keyboardType: TextInputType.number,
                       ),

              SizedBox(height: 20.h),
              buildDatePickerField(applicationDeadlineController, "Application Deadline"),
              SizedBox(height: 25.h),




          isLoading
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
            onTap: () async {
              setState(() => isLoading = true);
              try {
                final box = await Hive.openBox('userdata');
                final employerId = box.get('employer_id');
                if (employerId == null || employerId == "") {
                  throw Exception('Missing employerId');
                }
                final updateRequest = CreateJobRequestBody(
                  title: widget.title,
                  employmentType: widget.employment,
                  jobType: "Contract",
                  location: widget.location,
                  requirements: widget.requirement.split(',').map((e) => e.trim()).toList(),
                  description: widget.description,
                  applicationDeadline: applicationDeadlineController.text,
                  maxExperience: maxController.text,
                  minExperience: minController.text,
                  salaryMax: salaryMaxController.text,
                  salaryMin: salaryMinController.text,
                  employerId: employerId.toString(),
                );
                await ref.read(employerPostProvider(updateRequest.toJson()).future);

                // Success → Navigate
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              } catch (e) {
                // if (mounted) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Error: ${e.toString()}')),
                //   );
                // }
              } finally {
                if (mounted) {
                  setState(() => isLoading = false);
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 53.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: const Color(0xFF0A66C2),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: GoogleFonts.alexandria(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
            ],
          ),
        ),
      ),
    );
  }

/*  // Simple TextField builder for reuse
  Widget buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }*/






  Widget buildDatePickerField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true, // Prevent manual typing
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(), // Only allow dates after today
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          // Format date to e.g. 2025-06-30
          final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
    );
  }


}



class TextFieldBody extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  TextInputType keyboardType = TextInputType.text;
  TextFieldBody({
    super.key,
    required this.hint,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
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