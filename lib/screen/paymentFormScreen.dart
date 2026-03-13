// import 'dart:io';
// import 'package:ai_powered_app/core/network/api.state.dart';
// import 'package:ai_powered_app/core/utils/preety.dio.dart';
// import 'package:ai_powered_app/data/models/paymentResModel.dart';
// import 'package:ai_powered_app/screen/resister.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PaymentFormScreen extends StatefulWidget {
//   final String title;
//   final String amount;
//   const PaymentFormScreen({Key? key, required this.title, required this.amount})
//     : super(key: key);

//   @override
//   State<PaymentFormScreen> createState() => _PaymentFormScreenState();
// }

// class _PaymentFormScreenState extends State<PaymentFormScreen> {
//   final TextEditingController transIdController = TextEditingController();

//   File? _selectedImage;
//   bool _buttonLoader = false;

//   int amount = 0;

//   @override
//   void initState() {
//     super.initState();

//     amount = (double.tryParse(widget.amount) ?? 0).toInt();
//   }

//   /// PICK IMAGE
//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Image pick failed");
//     }
//   }

//   /// START UPI PAYMENT
//   Future<void> startUpiPayment() async {
//     try {
//       final String upiId = "pkt-8104155166@okbizaxis";
//       final String name = "RAJVEER FACILITY SERVICES";
//       final String note = "Registration Fee";
//       final String txnRef = "T${DateTime.now().millisecondsSinceEpoch}";

//       final String upiUrl =
//           'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(name)}&tn=${Uri.encodeComponent(note)}&am=${amount}&cu=INR&tr=$txnRef';

//       final Uri uri = Uri.parse(upiUrl);

//       if (await canLaunchUrl(uri)) {
//         await launchUrl(
//           uri,

//           //  mode: LaunchMode.externalApplication,
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("No UPI Apps found")));
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Payment app launch failed");
//     }
//   }

//   Future<void> submitPayment() async {
//     if (transIdController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter transaction ID")),
//       );
//       return;
//     }

//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please upload screenshot")));
//       return;
//     }

//     try {
//       setState(() {
//         _buttonLoader = true;
//       });

//       final service = APIStateNetwork(createDio());

//       final response = await service.matrimonyPayment(
//         amount.toString(),
//         transIdController.text.trim(),
//         _selectedImage!,
//       );

//       if (response.transactionId != null &&
//           response.transactionId!.isNotEmpty) {
//         Fluttertoast.showToast(msg: "Payment Success");

//         Navigator.pop(context, response.transactionId);
//       } else {
//         Fluttertoast.showToast(msg: "Payment Failed");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Payment error");
//     } finally {
//       setState(() {
//         _buttonLoader = false;
//       });
//     }
//   }

//   Color _getThemeColor(String title) {
//     switch (title.toUpperCase()) {
//       case "MATRIMONY":
//         return const Color(0xFF97144d);
//       case "JOBS":
//         return const Color(0xFF0A66C2);
//       case "REAL ESTATE":
//         return const Color(0xFF00796B);
//       default:
//         return const Color(0xFF97144d);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Color themeColor = _getThemeColor(widget.title);

//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(title: const Text("Payment Verification")),

//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 20,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Complete Payment",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 "Enter transaction details to verify your payment.",
//                 style: TextStyle(color: Colors.grey[600]),
//               ),

//               const SizedBox(height: 25),

//               const Text(
//                 "Payable Amount",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 8),

//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//                 decoration: BoxDecoration(
//                   color: themeColor.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(color: themeColor.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.currency_rupee, color: themeColor),
//                     const SizedBox(width: 10),
//                     Text(
//                       amount.toString(),
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: themeColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               ElevatedButton(
//                 onPressed: startUpiPayment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child: const Text(
//                   "Pay Now",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               const Text(
//                 "Transaction ID",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 8),

//               TextField(
//                 controller: transIdController,
//                 decoration: InputDecoration(
//                   hintText: "Enter UTR / Transaction ID",
//                   prefixIcon: Icon(Icons.receipt_long, color: themeColor),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 "Upload Screenshot",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child:
//                       _selectedImage == null
//                           ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               Icon(
//                                 Icons.add_photo_alternate_outlined,
//                                 size: 40,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 5),
//                               Text("Tap to select screenshot"),
//                             ],
//                           )
//                           : ClipRRect(
//                             borderRadius: BorderRadius.circular(15),
//                             child: Image.file(
//                               _selectedImage!,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _buttonLoader ? null : submitPayment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: themeColor,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child:
//                     _buttonLoader
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "Submit",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_powered_app/core/network/api.state.dart';
import 'package:ai_powered_app/core/network/job.state.dart';
import 'package:ai_powered_app/core/network/realState.state.dart';
import 'package:ai_powered_app/core/utils/preety.dio.dart';
import 'package:ai_powered_app/screen/resister.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentFormScreen extends StatefulWidget {
  final String title;
  final String amount;
  const PaymentFormScreen({Key? key, required this.title, required this.amount})
    : super(key: key);

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final TextEditingController transIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool _buttonLoader = false;
  int amount = 0;

  @override
  void initState() {
    super.initState();
    amount = (double.tryParse(widget.amount) ?? 0).toInt();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Image pick failed");
    }
  }

  Future<void> startUpiPayment() async {
    try {
      final String upiId = "pkt-8104155166@okbizaxis";
      final String name = "RAJVEER FACILITY SERVICES";
      final String note = "Registration Fee";
      final String txnRef = "T${DateTime.now().millisecondsSinceEpoch}";
      final String upiUrl =
          'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(name)}&tn=${Uri.encodeComponent(note)}&am=$amount&cu=INR&tr=$txnRef';
      final Uri uri = Uri.parse(upiUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No UPI Apps found")));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Payment app launch failed");
    }
  }

  Future<void> submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please upload screenshot")));
      return;
    }

    try {
      setState(() => _buttonLoader = true);
      // final service = APIStateNetwork(createDio());
      // final response = await service.matrimonyPayment(
      //   amount.toString(),
      //   transIdController.text.trim(),
      //   _selectedImage!,
      // );
      // if (response.transactionId != null &&
      //     response.transactionId!.isNotEmpty) {
      //   Fluttertoast.showToast(msg: "Payment Success");
      //   Navigator.pop(context, response.transactionId);
      // } else {
      //   Fluttertoast.showToast(msg: "Payment Failed");
      // }
      dynamic response;
      final dio = createDio();
      final String currentTitle = widget.title;

      if (currentTitle == "JOBS") {
        final service = JobApiNetwork(dio);
        response = await service.jobPayment(
          amount.toString(),
          transIdController.text.trim(),
          _selectedImage!,
        );
      } else if (currentTitle == "REAL ESTATE") {
        final service = RealStateState(dio);

        response = await service.realStatePayment(
          amount.toString(),
          transIdController.text.trim(),
          _selectedImage!,
        );
      } else {
        final service = APIStateNetwork(createDio());
        response = await service.matrimonyPayment(
          amount.toString(),
          transIdController.text.trim(),
          _selectedImage!,
        );
      }

      // Response check logic
      if (response != null &&
          response.transactionId != null &&
          response.transactionId!.isNotEmpty) {
        Fluttertoast.showToast(msg: "Payment Store Success");
        Navigator.pop(context, response.transactionId);
      } else {
        Fluttertoast.showToast(msg: "Payment Verification Failed");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() => _buttonLoader = false);
    }
  }

  Color _getThemeColor(String title) {
    switch (title.toUpperCase()) {
      case "MATRIMONY":
        return const Color(0xFF97144d);
      case "JOBS":
        return const Color(0xFF0A66C2);
      case "REAL ESTATE":
        return const Color(0xFF00796B);
      default:
        return const Color(0xFF97144d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = _getThemeColor(widget.title);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Payment Verification",
          style: GoogleFonts.gothicA1(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Complete Payment",
                  style: GoogleFonts.gothicA1(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter transaction details to verify your payment.",
                  style: GoogleFonts.gothicA1(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.h),

                _buildLabel("Payable Amount"),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: themeColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: themeColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        amount.toString(),
                        style: GoogleFonts.gothicA1(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                _buildActionButton(
                  title: "Pay via UPI App",
                  color: Colors.green[700]!,
                  onTap: startUpiPayment,
                  icon: Icons.account_balance_wallet_outlined,
                ),

                SizedBox(height: 30.h),
                const Divider(),
                SizedBox(height: 20.h),

                _buildLabel("Transaction ID / UTR"),
                _buildTextField(
                  controller: transIdController,
                  hint: "Enter 12 digit UTR number",
                  themeColor: themeColor,
                  icon: Icons.receipt_long,
                ),

                SizedBox(height: 25.h),
                _buildLabel("Upload Screenshot"),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    ),
                    child:
                        _selectedImage == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40.sp,
                                  color: themeColor,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Tap to select screenshot",
                                  style: GoogleFonts.gothicA1(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: 40.h),
                _buildSubmitButton(themeColor),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color themeColor,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 12,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter transaction ID";
          }
          if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
            return "Enter valid 12 digit UTR number";
          }
          return null;
        },
        decoration: InputDecoration(
          counterText: "",

          prefixIcon: Icon(icon, color: themeColor),
          hintText: hint,
          hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),

          filled: true,
          fillColor: Colors.white,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: themeColor, width: 1.5),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              title,
              style: GoogleFonts.gothicA1(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Color themeColor) {
    return GestureDetector(
      onTap: _buttonLoader ? null : submitPayment,
      child: Container(
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child:
              _buttonLoader
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    "Verify & Submit",
                    style: GoogleFonts.gothicA1(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }
}
