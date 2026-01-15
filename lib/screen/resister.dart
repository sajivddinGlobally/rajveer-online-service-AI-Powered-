import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../core/auth/login.auth.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({super.key, required this.title});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late Razorpay _razorpay;
  bool _buttonLoader = false;

  String? _tempToken;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? listRole;
  String? subRole;
  String? listGender;
  File? _selectedFile;
  final roleList = ["Buyer", "Seller"];
  final genderList = ["Male", "Female"];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Widget _getFilePreview(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      return Image.file(file, fit: BoxFit.cover, width: double.infinity);
    } else if (ext == 'pdf') {
      return const Center(
        child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 60),
      );
    } else {
      return const Center(
        child: Icon(Icons.insert_drive_file, color: Colors.blue, size: 60),
      );
    }
  }

  void checkresisterAlready() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _buttonLoader = true);

    String category = widget.title.toUpperCase();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    bool alreadyExists = false;

    if (category == "JOBS") {
      alreadyExists = await Auth.checkUserExists(
        endpoint: "job",
        phone: phone,
        email: email,
        context: context,
      );
    } else if (category == "REAL ESTATE") {
      alreadyExists = await Auth.checkUserExists(
        endpoint: "realestateuser",
        phone: phone,
        email: email,
        context: context,
      );
    } else {
      alreadyExists = await Auth.checkUserExists(
        endpoint: "matrimony",
        phone: phone,
        email: email,
        context: context,
      );
    }

    if (alreadyExists) {
      // Already registered → Block payment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This user is already registered!"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _buttonLoader = false);
      return;
    }

    // Naya user hai → Payment shuru karo
    _initiatePaymentAndRegister();
  }

  void _initiatePaymentAndRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.title.toUpperCase() == "JOBS" && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your resume"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _buttonLoader = true);

    try {
      // Step 1: Get Razorpay Order ID from your backend
      // final String orderId = await Auth.paymentCreateApi(
      //   widget.title == "REAL ESTATE"
      //       ? "realestate"
      //       : widget.title == "JOBS"
      //       ? "job"
      //       : widget.title == "MATRIMONY"
      //       ? "matrimony"
      //       : "",
      //   // "1", // amount in paise (₹500)
      //   "INR",
      //   "${widget.title} Registration",
      //   context,
      // );

      final Map<String, String> paymentData = await Auth.paymentCreateApi(
        // Map receive karo
        widget.title == "REAL ESTATE"
            ? "realestate"
            : widget.title == "JOBS"
            ? "job"
            : widget.title == "MATRIMONY"
            ? "matrimony"
            : "",
        "INR",
        "${widget.title} Registration",
        context,
      );

      final String orderId = paymentData['orderId']!;
      _tempToken = paymentData['tempToken'];

      // Step 2: Open Razorpay Checkout
      var options = {
        // 'key': 'rzp_live_RiLH4JLherWNG6', // old rajveer online service
        'key': 'rzp_test_S3Hx4JUgiTpEAO', // new test rajveer online service
        // 'amount': 1, // amount in paise
        'name': '${widget.title} Registration',
        'order_id': orderId, // This is critical — comes from your backend
        'description': 'Registration Fee',
        'timeout': 300, // in seconds
        'prefill': {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'contact': phoneController.text.trim(),
        },
        'theme': {'color': '#97144c4a1'},
      };

      _razorpay.open(options);
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Payment initiation failed: $e"), backgroundColor: Colors.red),
      // );
      setState(() => _buttonLoader = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Step 1: Verify payment on your backend (signature + capture check)
      final verifyData = await Auth.paymentVerifyApi(
        response.paymentId!,
        response.orderId!,
        response.signature!,
        context,
      );

      // Check if backend confirmed payment as "paid"
      final paymentStatus = verifyData['payment']['status'];
      if (paymentStatus != "paid") {
        throw Exception(
          "Payment not confirmed by server. Status: $paymentStatus",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Successful! Completing registration..."),
          backgroundColor: Colors.green,
        ),
      );

      // Step 2: Proceed with registration based on type
      if (widget.title.toUpperCase() == "JOBS") {
        await Auth.registerJobSeeker(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phone: phoneController.text.trim(),
          resumeFile: _selectedFile!,
          tempToken: _tempToken!,
          context: context,

          // onSuccess: _showSuccessAndNavigate,
        );
        _showSuccessAndNavigate();
      } else if (widget.title.toUpperCase() == "REAL ESTATE") {
        await Auth.registerRealState(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          phoneController.text.trim(),
          listRole == "Seller" ? "agent" : "buyer",
          listRole == "Seller" ? (subRole ?? "") : "",
          _tempToken!,
          context,
        );
        _showSuccessAndNavigate();
      } else {
        // Matrimony or others
        await Auth.register(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          phoneController.text.trim(),
          ageController.text,
          listGender?.toLowerCase() ?? "",
          dobController.text,
          _tempToken!,
          context,
        );
        _showSuccessAndNavigate();
      }
    } catch (e) {
      // Any error: verification, network, registration
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Error: $e"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      if (mounted) {
        setState(() => _buttonLoader = false);
      }
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment & Registration Successful!"),
        backgroundColor: Colors.green,
      ),
    );
    // Navigate to home/dashboard
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _buttonLoader = false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor(widget.title);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Register",
          style: GoogleFonts.gothicA1(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Full Name"),
              _buildTextField(
                controller: nameController,
                hint: "Enter Name",
                borderColor: themeColor,
              ),

              SizedBox(height: 15.h),
              _buildLabel("Email"),
              _buildTextField(
                controller: emailController,
                hint: "Enter Email",
                keyboardType: TextInputType.emailAddress,
                borderColor: themeColor,
                validator:
                    (v) =>
                        v!.trim().isEmpty
                            ? "Enter email"
                            : !v.contains("@")
                            ? "Invalid email"
                            : null,
              ),

              SizedBox(height: 15.h),
              _buildLabel("Password"),
              _buildTextField(
                controller: passwordController,
                hint: "Enter Password",
                obscure: true,
                borderColor: themeColor,
                validator:
                    (v) => v!.trim().length < 6 ? "Min 6 characters" : null,
              ),

              SizedBox(height: 15.h),
              _buildLabel("Phone"),
              _buildTextField(
                controller: phoneController,
                hint: "Enter Phone",
                keyboardType: TextInputType.phone,
                maxLength: 10,
                borderColor: themeColor,
                validator:
                    (v) =>
                        v!.trim().length < 10 ? "Enter 10-digit phone" : null,
              ),

              SizedBox(height: 15.h),

              // REAL ESTATE SPECIFIC
              if (widget.title.toUpperCase() == "REAL ESTATE") ...[
                _buildLabel("Role"),
                BuildDropDown(
                  title: widget.title,
                  hint: "Select Role",
                  items: roleList,
                  value: listRole,
                  onChange: (v) {
                    setState(() {
                      listRole = v;
                      if (v != "Seller") subRole = null;
                    });
                  },
                ),
                SizedBox(height: 15.h),
                if (listRole == "Seller") ...[
                  _buildLabel("Seller Type"),
                  BuildDropDown(
                    title: "",
                    hint: "Agent or Owner",
                    items: const ["Agent", "Owner"],
                    value: subRole,
                    onChange: (v) => setState(() => subRole = v),
                  ),
                  SizedBox(height: 15.h),
                ],
              ],

              // MATRIMONY SPECIFIC
              if (widget.title.toUpperCase() == "MATRIMONY") ...[
                _buildLabel("Age"),
                _buildTextField(
                  controller: ageController,
                  hint: "Your Age",
                  keyboardType: TextInputType.number,
                  borderColor: themeColor,
                ),
                SizedBox(height: 15.h),
                _buildLabel("Gender"),
                BuildDropDown(
                  title: widget.title,
                  hint: "Select Gender",
                  items: genderList,
                  value: listGender,
                  onChange: (v) => setState(() => listGender = v),
                ),
                SizedBox(height: 15.h),
                _buildLabel("Date of Birth"),
                buildDatePickerField(dobController, "Select DOB"),
                SizedBox(height: 20.h),
              ],

              // JOBS SPECIFIC
              if (widget.title.toUpperCase() == "JOBS") ...[
                _buildLabel("Upload Resume"),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: themeColor, width: 2),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child:
                        _selectedFile == null
                            ? const Center(
                              child: Icon(
                                Icons.cloud_upload,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: _getFilePreview(_selectedFile!),
                            ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              // REGISTER BUTTON WITH PAYMENT
              GestureDetector(
                onTap: _buttonLoader ? null : checkresisterAlready,
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
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              "Pay & Register",
                              style: GoogleFonts.gothicA1(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: GoogleFonts.gothicA1(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                        TextSpan(
                          text: "Login",
                          style: GoogleFonts.gothicA1(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
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
    );
  }

  // Helper Widgets
  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    Color? borderColor,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: borderColor!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      validator: validator ?? (v) => v!.trim().isEmpty ? "Required" : null,
    );
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

  Widget buildDatePickerField(TextEditingController controller, String hint) {
    final themeColor = _getThemeColor(widget.title);
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: const Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: themeColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(1990),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.text =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        }
      },
    );
  }
}

// Dropdown Widget (unchanged but improved)
class BuildDropDown extends StatelessWidget {
  final String hint, title;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;

  const BuildDropDown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    this.value,
    required this.onChange,
  });

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
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: Colors.grey)),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color(0xFFDADADA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: _getThemeColor(title), width: 2),
        ),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChange,
    );
  }
}
