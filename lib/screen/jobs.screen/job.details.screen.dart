import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../data/providers/jobApply.dart';
import '../../data/providers/jobDetailProvider.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final dynamic jobId;
  const JobDetailsScreen(this.jobId, {super.key});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final jobDetailAsync = ref.watch(jobDetailProvider(widget.jobId.toString()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:

      Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h, bottom: 100.h),
            child: jobDetailAsync.when(
              data: (jobDetail) {
                final job = jobDetail.data;
                if (job == null) {
                  return const Center(child: Text("No job data available"));
                }

                // DEBUG (Remove in production)
                // print("Raw requirements: ${job.requirements}");
                // print("Type: ${job.requirements.runtimeType}");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vacancy Details",
                      style: GoogleFonts.alexandria(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildJobCard(job),
                    SizedBox(height: 30.h),
                    _sectionTitle("Job Description"),
                    _sectionContent(job.description ?? "No description available"),
                    SizedBox(height: 30.h),
                    _sectionTitle("Requirements"),
                    _buildRequirementsList(job.requirements),
                    SizedBox(height: 30.h),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                padding: EdgeInsets.all(20.h),
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30.h,
            left: 24.w,
            right: 24.w,
            child: _buildApplyButton(),
          ),
        ],
      ),

    );
  }

  // ====================== JOB CARD ======================
  Widget _buildJobCard(dynamic job) {
    final String salary = job?.salaryMin != null && job?.salaryMax != null
        ? "₹${job.salaryMin} - ₹${job.salaryMax}"
        : job?.salaryRange ?? "Salary not specified";

    final String employmentType = switch (job?.employmentType) {
      'full_time' => 'Full Time',
      'part_time' => 'Part Time',
      _ => job?.employmentType ?? 'Not specified',
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 40,
            spreadRadius: 0,
            color: Color.fromARGB(12, 10, 102, 194),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                      color: Colors.white,
                      width: 24.w,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job?.title ?? "Untitled Job",
                        style: GoogleFonts.alexandria(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                      Text(
                        job?.company ?? "Unknown Company",
                        style: GoogleFonts.alexandria(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9A97AE),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            _buildJobInfoRow(Icons.location_on_outlined, job?.location ?? "Not specified"),
            SizedBox(height: 10.h),
            _buildJobInfoRow(Icons.currency_rupee, salary),
            SizedBox(height: 10.h),
            Row(
              children: [
                _tag(employmentType),
                SizedBox(width: 8.w),
                if (job?.minExperience != null || job?.maxExperience != null)
                  _tag("${job.minExperience}–${job.maxExperience} Yrs"),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: const Color(0xFF9A97AE)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: GoogleFonts.alexandria(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9A97AE),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
  Widget _buildRequirementsList(dynamic requirements) {
    List<String> reqList = [];

    if (requirements == null || requirements.toString().trim().isEmpty) {
      return _sectionContent("No requirements specified");
    }

    String raw = requirements.toString().trim();

    try {
      // Step 1: Remove outer [ ]
      if (raw.startsWith('[')) raw = raw.substring(1);
      if (raw.endsWith(']')) raw = raw.substring(0, raw.length - 1);

      // Step 2: Remove outer quotes
      if (raw.startsWith('"') && raw.endsWith('"')) {
        raw = raw.substring(1, raw.length - 1);
      }

      // Step 3: Fix ALL escapes: \" , \' , \\ → normal
      raw = raw
          .replaceAll(r'\"', '"')
          .replaceAll(r"\'", "'")
          .replaceAll(r'\\', r'\');

      // Step 4: Remove ALL quotes around items
      raw = raw.replaceAll("'", "").replaceAll('"', '');

      // Step 5: Split by comma (now safe)
      reqList = raw
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

    } catch (e) {
      reqList = [raw];
    }

    if (reqList.isEmpty) {
      return _sectionContent("No requirements specified");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reqList.map((req) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: GoogleFonts.alexandria(fontSize: 16.sp, color: const Color(0xFF878599))),
              Expanded(
                child: Text(
                  req,
                  style: GoogleFonts.alexandria(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF878599),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ====================== APPLY BUTTON ======================
  Widget _buildApplyButton() {
    return GestureDetector(
      onTap: () async {
        final jobDetail = ref.read(jobDetailProvider(widget.jobId.toString()));
        final job = jobDetail.value?.data;

        if (job?.id == null) {
          Fluttertoast.showToast(msg: "Job details not loaded");
          return;
        }

        final box = await Hive.openBox('userdata');
        final userId = box.get('user_id');

        if (userId == null) {
          Fluttertoast.showToast(msg: "Please login to apply");
          return;
        }

        setState(() => isLoading = true);

        try {
          await ref.read(jobApplyProvider({
            "job_id": job!.id,
            "user_id": userId,
            "cover_letter": "I'm interested in this position"
          }).future);

          Fluttertoast.showToast(msg: "Application submitted!");
          Navigator.pop(context);
        } catch (e) {
          Fluttertoast.showToast(msg: "Failed to apply: ${e.toString()}");
        } finally {
          setState(() => isLoading = false);
        }
      },
      child: Container(
        width: double.infinity,
        height: 74.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xFF0A66C2),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 4), blurRadius: 10, color: Color(0x40000000)),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
          )
              : Text(
            "Apply Now",
            style: GoogleFonts.alexandria(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ====================== HELPER WIDGETS ======================
  Widget _tag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDF2),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.alexandria(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1E1E1E),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.alexandria(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(
      text,
      style: GoogleFonts.alexandria(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF878599),
        letterSpacing: -0.1,
      ),
    );
  }
}