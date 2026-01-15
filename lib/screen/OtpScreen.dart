


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/auth/login.auth.dart';

class Otpscreen extends StatefulWidget {
  final String phoneNumber;
  final String colorTitle;
  const Otpscreen({
    Key? key,
    required this.phoneNumber,
    required this.colorTitle,
  }) : super(key: key);

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  int? _resendToken;
  bool _isLoading = false;
  bool _otpSent = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _sendOtp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }
  Color get _primaryColor {
    switch (widget.colorTitle.toUpperCase()) {
      case "MATRIMONY":
        return const Color(0xFF97144D);
      case "JOBS":
        return const Color(0xFF0A66C2);
      case "REAL ESTATE":
        return const Color(0xFF00796B);
      default:
        return const Color(0xFF97144D);
    }
  }
  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _otpSent = false;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${widget.phoneNumber}',
      timeout: const Duration(seconds: 60),
      forceResendingToken: _resendToken,
      verificationCompleted: (credential) => _signIn(credential),
      verificationFailed: (e) {
        setState(() => _isLoading = false);
        String msg = e.message ?? 'Verification failed';
        if (e.code == 'too-many-requests') {
          msg = 'Too many attempts. Try after 1 hour or add test number in Firebase.';
        }
        _showToast(msg, isError: true);
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;

        // Clear previous OTP
        for (var c in _otpControllers) c.clear();
        _focusNodes[0].requestFocus();

        setState(() {
          _isLoading = false;
          _otpSent = true;
        });
        _showToast('OTP sent successfully!');
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }
  Future<void> _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showToast('Please enter complete 6-digit OTP', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _signIn(credential);

    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      _showToast(e.code == 'invalid-verification-code' ? 'Wrong OTP' : 'Invalid OTP',
          isError: true);
    } catch (e) {
      setState(() => _isLoading = false);
      _showToast('Something went wrong', isError: true);
    }
  }
  Future<void> _signIn(PhoneAuthCredential credential) async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        _showToast('Login failed. User not found.', isError: true);
        setState(() => _isLoading = false);
        return;
      }

      final idToken = await user.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        _showToast('Failed to get authentication token.', isError: true);
        setState(() => _isLoading = false);
        return;
      }

      // Title ko uppercase kar rahe hain
      final title = widget.colorTitle.toUpperCase().trim();

      if (title == "JOBS") {
        await Auth.loginFirbaseJob(idToken, context);
      } else if (title == "REAL ESTATE") {
        await Auth.loginFirbaseRealState(idToken, context);
      } else {
        await Auth.loginFirbase(idToken, context);
      }

      // Success ke baad loading false kar denge (agar Auth functions mein navigation ho raha hai to yeh chalega)
      // Agar Auth functions khud navigation karte hain to yeh line skip ho jayegi – koi issue nahi
      if (mounted) {
        setState(() => _isLoading = false);
      }

    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Try again.';

      if (e.code == 'invalid-verification-code') {
        message = 'Invalid OTP. Please check and try again.';
      } else if (e.code == 'session-expired') {
        message = 'OTP expired. Please request a new one.';
      }

      _showToast(message, isError: true);
      if (mounted) setState(() => _isLoading = false);

    } catch (e) {
      _showToast('Something went wrong. Please try again.', isError: true);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showToast(String msg, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:

      AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "Verify Phone",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body:


      FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [

              SizedBox(height: 30.h),
              Icon(Icons.sms_rounded, size: 80.sp, color: _primaryColor),
              SizedBox(height: 20.h),
              Text(
                "Verification Code",
                style: GoogleFonts.poppins(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "We have sent OTP to",
                style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 8.h),
              Text(
                "+91 ${widget.phoneNumber}",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 55.w,
                    height: 65.h,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: _primaryColor, width: 2.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        // Auto submit on 6th digit
                        if (index == 5 && value.length == 1) {
                          String full = _otpControllers.map((c) => c.text).join();
                          if (full.length == 6) {
                            _verifyOtp();
                          }
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Verify & Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: (_isLoading || !_otpSent) ? null : _sendOtp,
                child: _isLoading
                    ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
                    : RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 15.sp),
                    children: [
                      const TextSpan(text: "Didn't receive code? "),
                      TextSpan(
                        text: "Resend OTP",
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

            ],
          ),
        ),
      ),


    );
  }
}