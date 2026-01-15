import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../data/models/jobApplicationModel.dart';
import '../../data/providers/myJob.dart';

class MyJobApplication extends ConsumerStatefulWidget {
  const MyJobApplication({super.key});
  @override
  ConsumerState<MyJobApplication> createState() => _MyJobApplicationState();
}

class _MyJobApplicationState extends ConsumerState<MyJobApplication> {

  // ... other existing variables ...
  String? userId; // Make nullable since we'll load it asynchronously

  @override
  void initState() {
    super.initState();
    // _loadUserId();
  }

  // Future<void> _loadUserId() async {
  //   final box = await Hive.openBox('userdata');
  //   setState(() {
  //     userId = box.get('userName');
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final jobApplicationsAsync = ref.watch(myJobsBasedProvider);

    return Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
      body:

      // Column(children: [
      //   SizedBox(height: 60.h),
      //   Row(
      //     children: [
      //       SizedBox(width: 24.w),
      //       Container(
      //         width: 40.w,
      //         height: 40.h,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10.r),
      //           color: const Color(0xFF0A66C2),
      //         ),
      //         child: Center(
      //           child: Image.asset(
      //             "assets/rajveer.png",
      //             color: const Color(0xFFFFFFFF),
      //           ),
      //         ),
      //       ),
      //       SizedBox(width: 10.w),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             "Job Portal",
      //             style: GoogleFonts.alexandria(
      //               fontSize: 18.sp,
      //               fontWeight: FontWeight.w500,
      //               color: const Color(0xFF030016),
      //
      //             ),
      //           ),
      //           Text(
      //             '$userId',
      //             style: GoogleFonts.alexandria(
      //               fontSize: 13.sp,
      //               fontWeight: FontWeight.w500,
      //               color: const Color(0xFF9A97AE),
      //
      //             ),
      //           ),
      //         ],
      //       ),
      //       const Spacer(),
      //       Container(
      //         width: 40.w,
      //         height: 40.h,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10.r),
      //           border: Border.all(color: Colors.black12, width: 1.w),
      //         ),
      //         child: const Center(child: Icon(Icons.notifications_none)),
      //       ),
      //       SizedBox(width: 24.w),
      //     ],
      //   ),
      //
      //
      //   jobApplicationsAsync.when(
      //     loading: () => const Center(child: CircularProgressIndicator()),
      //     error: (error, stack) => Center(child: Text('Error: $error')),
      //     data: (jobApplications) {
      //       if (jobApplications.applications.isEmpty) {
      //         return const Center(child: Text('No applications found'));
      //       }
      //       return
      //         Expanded(child:
      //         ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         itemCount: jobApplications.applications.length,
      //         itemBuilder: (context, index) {
      //           final application = jobApplications.applications[index];
      //           return _buildApplicationCard(application);
      //         },
      //         ) );
      //     },
      //   ),
      // ],)


      Column(
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

                  // Text(
                  //   '$userId',
                  //   style: GoogleFonts.alexandria(
                  //     fontSize: 13.sp,
                  //     fontWeight: FontWeight.w500,
                  //     color: const Color(0xFF9A97AE),
                  //   ),
                  // ),

                ],
              ),
              const Spacer(),

              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.black12, width: 1.w),
                ),
                child: const Center(child: Icon(Icons.notifications_none)),
              ),

              SizedBox(width: 24.w),

            ],
          ),
          Expanded( // Wrap the entire jobApplicationsAsync.when in Expanded
            child: jobApplicationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (jobApplications) {
                if (jobApplications.applications!.isEmpty) {
                  return Center(
                    child: Text(
                      'No applications found',
                      style: GoogleFonts.alexandria(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: jobApplications.applications!.length,
                  itemBuilder: (context, index) {
                    final application = jobApplications.applications![index];
                    return _buildApplicationCard(application);
                  },
                );
              },
            ),
          ),
        ],
      )

    );
  }

  Widget _buildApplicationCard(Application application) {
    // Format the appliedDate to DD-MM-YYYY
    final dateFormat = DateFormat('dd-MM-yyyy');
    final formattedDate = application.appliedDate != null
        ? dateFormat.format(application.appliedDate!)
        : "Not specified";
    return

      Container(
        margin: EdgeInsets.all(20),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

Row(children: [

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
  SizedBox(width: 10,),
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        application.jobTitle ?? "Untitled Job",
        style: GoogleFonts.alexandria(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E1E1E),
          
        ),
      ),
      Text(
        application.jobTitle ?? "Unknown Company",
        style: GoogleFonts.alexandria(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
    ],
  ),
],),

                  // ),
                  // ),
                  // SizedBox(width: 10.w),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    Text(
                      formattedDate,
                      style: GoogleFonts.alexandria(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9A97AE),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],)

                ],
              ),
              SizedBox(height: 15.h),


              // _buildJobInfoRow(Icons.location_on_outlined, application.appliedDate ?? "Not specified"),
              SizedBox(height: 10.h),

              SizedBox(height: 25.h),

            ],
          ),
        ),
      );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


JobApplicationListModel jobApplicationListModelFromJson(String str) => JobApplicationListModel.fromJson(json.decode(str));

String jobApplicationListModelToJson(JobApplicationListModel data) => json.encode(data.toJson());

class JobApplicationListModel {
  List<Application>? applications;

  JobApplicationListModel({
    this.applications,
  });

  factory JobApplicationListModel.fromJson(Map<String, dynamic> json) => JobApplicationListModel(
    applications: json["applications"] == null ? [] : List<Application>.from(json["applications"]!.map((x) => Application.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "applications": applications == null ? [] : List<dynamic>.from(applications!.map((x) => x.toJson())),
  };
}

class Application {
  int? applicationId;
  String? jobId;
  String? jobTitle;
  String? status;
  DateTime? appliedDate;

  Application({
    this.applicationId,
    this.jobId,
    this.jobTitle,
    this.status,
    this.appliedDate,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    applicationId: json["application_id"],
    jobId: json["job_id"],
    jobTitle: json["job_title"],
    status: json["status"],
    appliedDate: json["applied_date"] == null ? null : DateTime.parse(json["applied_date"]),
  );

  Map<String, dynamic> toJson() => {
    "application_id": applicationId,
    "job_id": jobId,
    "job_title": jobTitle,
    "status": status,
    "applied_date": "${appliedDate!.year.toString().padLeft(4, '0')}-${appliedDate!.month.toString().padLeft(2, '0')}-${appliedDate!.day.toString().padLeft(2, '0')}",
  };
}

