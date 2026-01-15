import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/PropertyAgentUserModel.dart';
import '../../data/providers/propertyBookUserList.dart';

class PropertyBookByUser extends ConsumerStatefulWidget {
  const PropertyBookByUser({super.key});

  @override
  ConsumerState<PropertyBookByUser> createState() => _PropertyBookByUserState();
}

class _PropertyBookByUserState extends ConsumerState<PropertyBookByUser> {
  @override
  Widget build(BuildContext context) {
    final bookingList = ref.watch(propertyBookUserListProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ Prevents auto-back

        title: Text(
          "My Bookings",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00796B),
      ),
      body: bookingList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.red),
              ),
            ),
        data: (model) {
          final bookings = model.bookings ?? [];
          if (bookings.isEmpty) {
            return Center(
              child: Text(
                "No bookings found.",
                style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final property = booking.property;
              return BookingCard(booking: booking, property: property);
            },
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final Property? property;

  const BookingCard({super.key, required this.booking, this.property});

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern(
      'en_IN',
    ).format(double.tryParse(property!.price ?? "") ?? 0);
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Title
            Text(
              property?.title ?? "Unknown Property",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1E1E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            // Booking Date and Time
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  "Date: ${booking.bookingDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF9A97AE),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  "Time: ${booking.bookingTime ?? 'N/A'}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF9A97AE),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            // Booking Status
            Row(
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                /* Text(
                  "Status: ${booking.status ?? 'N/A'}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: booking.status == 'confirmed'
                        ? Colors.green
                        : booking.status == 'pending'
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),*/
                Text(
                  "Status: ${booking.status != null ? booking.status![0].toUpperCase() + booking.status!.substring(1) : 'N/A'}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        booking.status == 'confirmed'
                            ? Colors.green
                            : booking.status == 'pending'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Property Price
            // Text(
            //   "Price: ₹${property?.price ?? 'N/A'}",
            //   style: GoogleFonts.inter(
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.w500,
            //     color: const Color(0xFF1E1E1E),
            //   ),
            Text(
              "₹$formattedPrice",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
