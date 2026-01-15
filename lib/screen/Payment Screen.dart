/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentPage(),
    );
  }
}


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay? _razorpay;
  TextEditingController _amountController = TextEditingController();
  final String _apiKey = 'rzp_test_1234567890abcdef'; // Your actual Key ID
  final String _apiSecret = '1234567890abcdefghijklmnop'; // Your actual Key Secret

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay!.clear();
    _amountController.dispose();
    super.dispose();
  }

  Future<String> createOrder(double amount) async {
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$_apiKey:$_apiSecret'))}';
    final Map<String, dynamic> body = {
      "amount": (amount * 100).toInt(), // Convert to paise
      "currency": "INR",
      "receipt": "rcpt_${DateTime.now().millisecondsSinceEpoch}"
    };

    final response = await http.post(
      Uri.parse("https://api.razorpay.com/v1/orders"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Failed to create order');
    }
  }

  void openCheckout(double amount, String orderId) {
    var options = {
      'key': _apiKey,
      'amount': (amount * 100).toInt(),
      'order_id': orderId,
      'name': 'Demo App',
      'description': 'Test Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
      'theme': {
        'color': '#5eba7d'
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay Payment Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Enter Amount (INR)',
                border: OutlineInputBorder(),
              ),
               keyboardType: TextInputType.number,
                        inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  // या इससे भी आसान और आम तरीका:
  FilteringTextInputFormatter.digitsOnly,
],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  double amount = double.parse(_amountController.text);
                  if (amount <= 0) {
                    Fluttertoast.showToast(msg: 'Please enter a valid amount');
                    return;
                  }
                  String orderId = await createOrder(amount);
                  openCheckout(amount, orderId);
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Error: $e');
                }
              },
              child: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Test Key
      'amount': 50000, // ₹500 in paise
      'name': 'Test App',
      'description': 'Testing Payment',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@example.com',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.code} | ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: ${response.walletName}");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Razorpay Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openCheckout,
          child: Text("Pay ₹500"),
        ),
      ),
    );
  }
}

