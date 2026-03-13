/*
import 'package:ai_powered_app/screen/resister.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/auth/login.auth.dart';
import 'Payment Screen.dart';

class LoginPage extends ConsumerStatefulWidget {
  final String title;
  LoginPage(this.title, {super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _buttonLoader = false;
  bool isAccepted = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login To Your Account", // Capitalized first letters
                    textAlign: TextAlign.start,
                    style: GoogleFonts.gothicA1(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF030016),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                _buildLabel("Enter Email"),
                _buildTextFormField(
                  _getLoginButtonColor(widget.title),
                  controller: emailController,
                  hint: "Enter Email Address",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 35.h),
                _buildLabel("Enter Password"),
                _buildTextFormField(
                  _getLoginButtonColor(widget.title),
                  controller: passwordController,
                  hint: "Enter Password",
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 5) {
                      return 'Password must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 0.h),



                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(-8.0, 0.0), // Negative offset to remove intrinsic left padding
                        child: Checkbox(
                          value: isAccepted,
                          activeColor:_getLoginButtonColor(widget.title),
                          onChanged: (value) {
                            setState(() {
                              isAccepted = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Remember Me",
                          textAlign: TextAlign.start,
                          // style: GoogleFonts.gothicA1(
                          //   fontSize: 16.sp,
                          //   fontWeight: FontWeight.w400,
                          //   color: Colors.black
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                GestureDetector(
                  onTap: () async {
                    if (_buttonLoader) return;
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    setState(() => _buttonLoader = true);
                    try {
                      if (widget.title.toUpperCase() == "JOBS") {
                        await Auth.jobsLogin(
                          emailController.text.trim(),
                          passwordController.text,
                          context,
                        );
                      } else if (widget.title.toUpperCase() == "REAL ESTATE") {
                        await Auth.realStateLogin(
                          emailController.text.trim(),
                          passwordController.text,
                          context,
                        );
                      } else {
                        await Auth.login(
                          emailController.text.trim(),
                          passwordController.text,
                          context,
                        );
                      }
                    } finally {
                      setState(() => _buttonLoader = false);
                    }
                  },
                  child: Center(
                    child:
                        _buttonLoader
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF9A97AE),
                                ),
                              ),
                            )
                            : Container(
                              width: double.infinity,
                              height: 53.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: _getLoginButtonColor(widget.title),
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.gothicA1(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color:  Colors.white,

                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 20.h),


                SizedBox(height: 24.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RegisterPage(title: widget.title),
                        ),
                      );
                    */
/*  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymentPage(),
                        ),
                      );*/ /*

                    },
                    child:
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Color for "Already have Account?"
                            ),
                          ),
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.gothicA1(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color:_getLoginButtonColor(widget.title)
                            ),
                          ),
                        ],
                      ),
                    ),


                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLoginButtonColor(String title) {
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
}

class WithBody extends StatelessWidget {
  final String image;
  const WithBody({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E1D8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(image, fit: BoxFit.contain),
      ),
    );
  }
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

Widget _buildTextFormField(
  Color getLoginButtonColor, {
  required TextEditingController controller,
  String? hint,
  bool obscure = false,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(color: getLoginButtonColor, width: 1.5.w),
  );

  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      hintText: hint,
      hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
      disabledBorder: border,
    ),
  );
}
*/

/*


import 'package:ai_powered_app/screen/resister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/auth/login.auth.dart';
import 'OtpScreen.dart';

class LoginPage extends ConsumerStatefulWidget {
  final String title;
  const LoginPage(this.title, {super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _buttonLoader = false;
  bool isAccepted = false;
  bool isPhoneLogin = false; // State to toggle between phone and email login
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Login To Your Account",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                SizedBox(height: 20.h),
                // Toggle Buttons for Login Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton(
                      title: "Login With Email",
                      isSelected: !isPhoneLogin,
                      onTap: () => setState(() => isPhoneLogin = false),
                    ),
                    SizedBox(width: 10.w),
                    _buildToggleButton(
                      title: "Login With Phone",
                      isSelected: isPhoneLogin,
                      onTap: () => setState(() => isPhoneLogin = true),
                    ),
                  ],
                ),


                SizedBox(height: 30.h),
                // Conditionally render form fields based on login mode
                if (isPhoneLogin) ...[
                  _buildLabel("Enter Mobile Number"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: phoneController,
                    hint: "Enter Mobile Number",
                    maxLength: 10, // Restrict to 10 digits
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                    ],
                     keyboardType: TextInputType.number,
                        inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  // या इससे भी आसान और आम तरीका:
  FilteringTextInputFormatter.digitsOnly,
],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      final phoneRegex = RegExp(r'^[6-9]\d{9}$');
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Enter a valid 10-digit Indian mobile number';
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  _buildLabel("Enter Email"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: emailController,
                    hint: "Enter Email Address",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 35.h),
                  _buildLabel("Enter Password"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: passwordController,
                    hint: "Enter Password",
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 5) {
                        return 'Password must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                ],
                if (!isPhoneLogin) ...[
                  SizedBox(height: 15.h),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(-8.0, 0.0),
                          child: Checkbox(
                            value: isAccepted,
                            activeColor: _getLoginButtonColor(widget.title),
                            onChanged: (value) {
                              setState(() {
                                isAccepted = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Remember Me",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 15.h),



                GestureDetector(
                  onTap: () async {
                    if (_buttonLoader) return;
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    setState(() => _buttonLoader = true);
                    try {
                      if (isPhoneLogin) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            Otpscreen(
                        colorTitle:  widget.title??"",
                          phoneNumber: '',
                          title: '',
                        )));

                      }
                      else {
                        if (widget.title.toUpperCase() == "JOBS") {
                          await Auth.jobsLogin(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        } else if (widget.title.toUpperCase() == "REAL ESTATE") {
                          await Auth.realStateLogin(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        } else {
                          await Auth.login(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        }
                      }
                    } finally {
                      setState(() => _buttonLoader = false);
                    }
                  },
                  
                  child: Center(
                    child: _buttonLoader
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF9A97AE),
                        ),
                      ),
                    )
                        :
                    Container(
                      width: double.infinity,
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: _getLoginButtonColor(widget.title),
                      ),
                      child: Center(
                        child: Text(
                          isPhoneLogin ? 'Login With Phone' : 'Login With Email',
                          style: GoogleFonts.gothicA1(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                

                SizedBox(height: 24.h),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(title: widget.title),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: _getLoginButtonColor(widget.title),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLoginButtonColor(String title) {
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

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? _getLoginButtonColor(widget.title) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          title,
          style: GoogleFonts.gothicA1(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class WithBody extends StatelessWidget {
  final String image;
  const WithBody({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6E1D8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(image, fit: BoxFit.contain),
      ),
    );
  }
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

*/
/*Widget _buildTextFormField(
    Color getLoginButtonColor, {
      required TextEditingController controller,
      String? hint,
      bool obscure = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
    }) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(color: getLoginButtonColor, width: 1.5.w),
  );
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      hintText: hint,
      hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
      disabledBorder: border,
    ),
  );
}*/ /*


Widget _buildTextFormField(
    Color getLoginButtonColor, {
      required TextEditingController controller,
      String? hint,
      bool obscure = false,
      TextInputType keyboardType = TextInputType.text,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
    }) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(color: getLoginButtonColor, width: 1.5.w),
  );

  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    maxLength: maxLength,
    // inputFormatters: inputFormatters,
    validator: validator,
    decoration: InputDecoration(
      counterText: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      hintText: hint,
      hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
      disabledBorder: border,
    ),
  );
}




*/





import 'package:ai_powered_app/screen/forgotpassword.page.dart';
import 'package:ai_powered_app/screen/paymentFormScreen.dart';
import 'package:ai_powered_app/screen/resister.dart';
import 'package:ai_powered_app/screen/start.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/auth/login.auth.dart';
import 'OtpScreen.dart';

class LoginPage extends ConsumerStatefulWidget {
  final String title;
  const LoginPage(this.title, {super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _buttonLoader = false;
  bool isAccepted = false;
  bool isPhoneLogin = false; // State to toggle between phone and email login
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dismiss keyboard and clear focus when switching modes
  void _switchLoginMode(bool phoneLogin) {
    // Clear focus to dismiss keyboard
    FocusScope.of(context).unfocus();
    // Update login mode
    setState(() {
      isPhoneLogin = phoneLogin;
      // Clear fields to avoid stale data
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        // padding: EdgeInsets.all(20.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset("assets/loginlogo.png")),
                // Center(child: Image.asset("assets/loginlogo2.png")),
                SizedBox(height: 25.h),

                Text(
                  "Login To Your Account",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),

                SizedBox(height: 20.h),

                // Toggle Buttons for Login Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildToggleButton(
                      title: "Login With Email",
                      isSelected: !isPhoneLogin,
                      onTap: () => _switchLoginMode(false),
                    ),
                    SizedBox(width: 10.w),
                    _buildToggleButton(
                      title: "Login With Phone",
                      isSelected: isPhoneLogin,
                      onTap: () => _switchLoginMode(true),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                // Conditionally render form fields based on login mode
                if (isPhoneLogin) ...[
                  _buildLabel("Enter Mobile Number"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: phoneController,
                    hint: "Enter Mobile Number",
                    maxLength: 10,

                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // या इससे भी आसान और आम तरीका:
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      final phoneRegex = RegExp(r'^[6-9]\d{9}$');
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Enter a valid 10-digit Indian mobile number';
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  _buildLabel("Enter Email"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: emailController,
                    hint: "Enter Email Address",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Enter Password"),
                  _buildTextFormField(
                    _getLoginButtonColor(widget.title),
                    controller: passwordController,
                    hint: "Enter Password",
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          top: 0,
                          bottom: 0,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder:
                                (context) => ForgotPasswordPage(widget.title),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.gothicA1(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: _getLoginButtonColor(widget.title),
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () async {
                    if (_buttonLoader) return;
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    setState(() => _buttonLoader = true);
                    try {
                      if (isPhoneLogin) {
                        final title = widget.title.toUpperCase();

                        if (title == "JOBS") {
                          await Auth.checkNumberJob(
                            phoneController.text.trim(),
                            context,
                          );
                        } else if (title == "REAL ESTATE") {
                          await Auth.checkNumberRealState(
                            phoneController.text.trim(),
                            context,
                          );
                        } else {
                          await Auth.checkNumber(
                            phoneController.text.trim(),
                            context,
                          );
                        }
                      } else {
                        if (widget.title.toUpperCase() == "JOBS") {
                          await Auth.jobsLogin(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        } else if (widget.title.toUpperCase() ==
                            "REAL ESTATE") {
                          await Auth.realStateLogin(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        } else {
                          await Auth.login(
                            emailController.text.trim(),
                            passwordController.text,
                            context,
                          );
                        }
                      }
                    } finally {
                      setState(() => _buttonLoader = false);
                    }
                  },

                  child: Center(
                    child:
                        _buttonLoader
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF9A97AE),
                                ),
                              ),
                            )
                            : Container(
                              width: double.infinity,
                              height: 53.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: _getLoginButtonColor(widget.title),
                              ),
                              child: Center(
                                child: Text(
                                  isPhoneLogin
                                      ? 'Login With Phone'
                                      : 'Login With Email',
                                  style: GoogleFonts.gothicA1(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RegisterPage(title: widget.title,),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder:
                      //         (context) =>
                      //             PaymentFormScreen(title: widget.title),
                      //   ),
                      // );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: _getLoginButtonColor(widget.title),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 0,
                        bottom: 0,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Helpline : +91 89766 89112",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: _getLoginButtonColor(widget.title),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLoginButtonColor(String title) {
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

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? _getLoginButtonColor(widget.title)
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          title,
          style: GoogleFonts.gothicA1(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
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

  Widget _buildTextFormField(
    Color getLoginButtonColor, {
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: getLoginButtonColor, width: 1.5.w),
    );

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          focusedErrorBorder: border,
          disabledBorder: border,
        ),
      ),
    );
  }
}
