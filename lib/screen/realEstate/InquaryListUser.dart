import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/providers/InquaryListProvider.dart';

class UserInquiryListScreen extends ConsumerWidget {
  const UserInquiryListScreen({super.key});
  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiryAsyncValue = ref.watch(inquaryListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ Prevents auto-back
        title: Text(
          "Your Inquiries",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00796B),
      ),


      body: inquiryAsyncValue.when(
        data: (data) {
          print("Data block called: ${data.inquiries?.length ?? 0} inquiries");
          final inquiries = data.inquiries ?? [];
          if (inquiries.isEmpty) {
            return Center(
              child: Text(
                "No inquiries found.",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: inquiries.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final inquiry = inquiries[index];
              final propertyTitle = inquiry.property?.title ?? "No Title";
              final message = inquiry.message ?? "No Message";
              final date = formatDate(inquiry.sentDate);

              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propertyTitle,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      message,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4A4A4A),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () {
          print("Loading block called");
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          print("Error block called: $err");
          return Center(
            child: Text(
              "Data Not Available",
              style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
