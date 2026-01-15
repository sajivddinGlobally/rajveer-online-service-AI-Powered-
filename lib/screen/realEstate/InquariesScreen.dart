import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/providers/InquartProvider.dart';
// rest imports same...

class EnquariesScreen extends ConsumerStatefulWidget {
  final int? propertyId;
  const EnquariesScreen(this.propertyId, {super.key});

  @override
  ConsumerState<EnquariesScreen> createState() => _EnquariesScreenState();
}

class _EnquariesScreenState extends ConsumerState<EnquariesScreen> {
  final TextEditingController _messageController = TextEditingController();

  bool isLoading = false;

  Future<void> _sendInquiry() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message cannot be empty")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(inquriesProvider({
        'property_id': widget.propertyId,
        'message': message,
      }).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inquiry sent successfully")),
        );
        // Navigator.pop(context); // go back
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RealestateHomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RealestateHomePage()),
        );
        return false; // prevent default back action
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RealestateHomePage()),
              );
            },
          ),
          title: Text(
            "Enquiry",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Write your message",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: TextField(
                  controller: _messageController,
                  maxLines: 6,
                  style: GoogleFonts.inter(fontSize: 14.sp),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your message here...',
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _sendInquiry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    "Send Inquiry",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}
