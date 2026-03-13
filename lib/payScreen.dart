// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PayScreen extends StatelessWidget {

//   final Function onPaymentSuccess;

//   PayScreen({super.key, required this.onPaymentSuccess});

//   final String upiId = "pkt-8104155166@okbizaxis";
//   final String name = "RAJVEER FACILITY SERVICES PRIVATE LIMITED";

//   Future<void> launchUPI(BuildContext context) async {

//     final Uri uri = Uri.parse(
//       "upi://pay?pa=$upiId&pn=$name&am=100&cu=INR",
//     );

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);

//       /// After payment done user clicks button
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("If payment completed click confirm")),
//       );
//     } else {
//       throw 'Could not launch UPI app';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(title: Text("UPI Payment")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             ElevatedButton(
//               onPressed: () => launchUPI(context),
//               child: Text("Pay ₹100"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 onPaymentSuccess();
//                 Navigator.pop(context);
//               },
//               child: Text("Payment Done"),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }