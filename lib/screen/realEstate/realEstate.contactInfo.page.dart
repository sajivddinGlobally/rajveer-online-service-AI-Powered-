import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ai_powered_app/data/providers/createPrperty.dart';
import 'package:ai_powered_app/screen/realEstate/createPropertyPage.dart';
import 'package:ai_powered_app/screen/realEstate/property.realEstate.details.dart';
import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:ai_powered_app/screen/realEstate/upload.realEstate.page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../../data/models/UpdatePropertyModel.dart';
import '../../data/providers/propertyDetail.dart';
import 'location.realEstate.page.dart';

final ownerNameControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final mobileNumberControllerProvider =
    Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final emailControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

class RealestateContactinfoPage extends ConsumerStatefulWidget {
  final int? propertyId;
  const RealestateContactinfoPage(this.propertyId, {super.key});
  @override
  ConsumerState<RealestateContactinfoPage> createState() =>
      _RealestateContactinfoPageState();
}

class _RealestateContactinfoPageState
    extends ConsumerState<RealestateContactinfoPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    }
  }

  void _fetchAndSetPropertyData() async {
    final propertyId = widget.propertyId;
    if (propertyId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final propertyDetail = await ref.read(
        propertyDetailProvider(propertyId).future,
      );
      final property = propertyDetail.property;
      print('Property Detail: ${propertyDetail.toJson()}'); // Debug log
      if (property != null) {
        final ownerNameController = ref.read(ownerNameControllerProvider);
        final mobileNumberController = ref.read(mobileNumberControllerProvider);
        final emailController = ref.read(emailControllerProvider);
        setState(() {
          ownerNameController.text = property.agentName ?? '';
          mobileNumberController.text = property.mobileNumber ?? '';
          emailController.text = property.email ?? '';
        });

        print(
          'Set fields: agentName=${property.agentName}, mobileNumber=${property.mobileNumber}, email=${property.email}',
        );
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      print('Error fetching property data: $e'); // Debug log
      Fluttertoast.showToast(
        msg: "Failed to load property details: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void validateAndNavigate() {
    final ownerName = ref.read(ownerNameControllerProvider).text.trim();
    final mobileNumber = ref.read(mobileNumberControllerProvider).text.trim();
    final email = ref.read(emailControllerProvider).text.trim();

    if (ownerName.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Agent/Owner Name",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
      return;
    }
    if (mobileNumber.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Mobile Number",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
      return;
    }
    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter an email address",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email address",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
      return;
    }

    _submitProperty();
  }
  Future<void> _submitProperty() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      final box = await Hive.openBox('userdata');
      final userId = box.get('user_id');
      final price = int.tryParse(ref.read(priceControllerProvider).text);
      final bedrooms = int.tryParse(ref.read(bedroomsControllerProvider).text);
      final bathrooms = int.tryParse(
        ref.read(bathroomsControllerProvider).text,
      );
      final area = int.tryParse(ref.read(areaControllerProvider).text);
      final bhk = int.tryParse(ref.read(bhkProvider).toString());
      final landTypeProvider = StateProvider<String?>((ref) => null);

final bhkType = bhk ?? ref.read(landTypeProvider).toString();

      if (price == null ||
          area == null) {
        Fluttertoast.showToast(
          msg:
              "Please enter valid numeric values for price, bedrooms, bathrooms, and area",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        setState(() => isLoading = false);
        return;
      }

      final property = PropertyRequest(
        title: ref.read(titleControllerProvider).text,
        description: ref.read(descriptionControllerProvider).text,
        propertyType: ref.read(propertyTypeProvider),
        category: ref.read(propertyListProvider),
        price: price,
        location: ref.read(cityProvider),
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        area: area,
        userId: userId,
        agentName: ref.read(ownerNameControllerProvider).text,
        mobileNumber: ref.read(mobileNumberControllerProvider).text,
        email: ref.read(emailControllerProvider).text,
        localArea: ref.read(localAreaControllerProvider).text,
        bhk: bhkType,
        furnishSuch: ref.read(furnishingProvider),
        completeAddress: ref.read(completeAddressControllerProvider).text,
      );
      final List<File> imageFiles = ref.read(propertyImageProvider);
      // Helper function to clear form fields
      void clearFormFields() {
        // Reset text controllers
        ref.read(priceControllerProvider).clear();
        ref.read(titleControllerProvider).clear();
        ref.read(descriptionControllerProvider).clear();
        ref.read(bedroomsControllerProvider).clear();
        ref.read(bathroomsControllerProvider).clear();
        ref.read(areaControllerProvider).clear();
        ref.read(ownerNameControllerProvider).clear();
        ref.read(mobileNumberControllerProvider).clear();
        ref.read(emailControllerProvider).clear();
        ref.read(localAreaControllerProvider).clear();
        ref.read(completeAddressControllerProvider).clear();
        // Reset state providers
        ref.read(propertyTypeProvider.notifier).state = null;
        ref.read(propertyListProvider.notifier).state = null;
        ref.read(bhkProvider.notifier).state = null;
        ref.read(cityProvider.notifier).state = null;
        ref.read(furnishingProvider.notifier).state = null;
        // ref.read(amenitiesProvider.notifier).state = []; // Uncomment if amenitiesProvider is defined
        // Reset image provider
        ref.read(propertyImageProvider.notifier).state = [];
      }

      if (widget.propertyId != null && widget.propertyId != -1) {
        final List<File> imageFiles = ref.read(propertyImageProvider);
        await updatePropertyFunction(
          propertyId: widget.propertyId!.toInt(),
          userId: userId,
          title: property.title!,
          description: property.description!,
          price: price,
          bedrooms: bedrooms,
          bathrooms: bathrooms,
          area: area,
          photo: imageFiles.isNotEmpty ? imageFiles[0] : null,
          images: imageFiles,
        );

        Fluttertoast.showToast(
          msg: "Property updated successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.sp,
        );

        // Clear form fields after successful update
        clearFormFields();
      } else {
        // Create property
        await CreatePropertyProvider.submitProperty(
          property: property,
          context: context,
          singleImage: imageFiles.isNotEmpty ? imageFiles[0] : null,
          multipleImages: imageFiles,
        );

        Fluttertoast.showToast(
          msg: "Property created successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.sp,
        );

        // Clear form fields after successful creation
        clearFormFields();
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RealestateHomePage()),
        );
      }
    } catch (e) {
      void clearFormFields() {
        // Reset text controllers
        ref.read(priceControllerProvider).clear();
        ref.read(titleControllerProvider).clear();
        ref.read(descriptionControllerProvider).clear();
        ref.read(bedroomsControllerProvider).clear();
        ref.read(bathroomsControllerProvider).clear();
        ref.read(areaControllerProvider).clear();
        ref.read(ownerNameControllerProvider).clear();
        ref.read(mobileNumberControllerProvider).clear();
        ref.read(emailControllerProvider).clear();
        ref.read(localAreaControllerProvider).clear();
        ref.read(completeAddressControllerProvider).clear();

        // Reset state providers
        ref.read(propertyTypeProvider.notifier).state = null;
        ref.read(propertyListProvider.notifier).state = null;
        ref.read(bhkProvider.notifier).state = null;
        ref.read(cityProvider.notifier).state = null;
        ref.read(furnishingProvider.notifier).state = null;
        // ref.read(amenitiesProvider.notifier).state = []; // Uncomment if amenitiesProvider is defined

        // Reset image provider
        ref.read(propertyImageProvider.notifier).state = [];
      }

      clearFormFields();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RealestateHomePage()),
      );
      print('Error submitting property: $e');
      Fluttertoast.showToast(
        msg: "Failed to submit property: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final ownerNameController = ref.watch(ownerNameControllerProvider);
    final mobileNumberController = ref.watch(mobileNumberControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final isUpdateMode = widget.propertyId != null && widget.propertyId != -1;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading && isUpdateMode
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        isUpdateMode ? "View Contact Info" : "Contact Info",
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF030016),
                          letterSpacing: -1.3,
                        ),
                      ),
                      Text(
                        isUpdateMode
                            ? "Contact details (read-only)"
                            : "Tell us about your contact details",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9A97AE),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Seller Name"),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: ownerNameController,
                        enabled: !isUpdateMode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF00796B),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          hintText: "Enter Owner/Seller Name",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Mobile Number"),
                      SizedBox(height: 10.h),
                      TextField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: mobileNumberController,
                        enabled: !isUpdateMode,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF00796B),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          hintText: "Enter Mobile Number",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Email Address"),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: emailController,
                        enabled: !isUpdateMode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF00796B),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          hintText: "Enter Email ID",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: validateAndNavigate,
                        child: Container(
                          width: 392.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color:
                            // isUpdateMode ? Colors.grey :
                            const Color(0xFF00796B),
                          ),
                          child: Center(
                            child:
                                isLoading
                                    ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      // isUpdateMode ? "Update (Disabled)" :
                                      "Submit",
                                      style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
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

  Future<void> updatePropertyFunction({
    required int userId,
    required String title,
    required String description,
    required int? price,
    required int? bedrooms,
    required int? bathrooms,
    required int? area,
    required int propertyId,
    File? photo,
    List<File>? images,
  }) async {
    final uri = Uri.parse(
      'https://matrimony.rajveerfacility.in/api/update-properties',
    );

    final box = await Hive.openBox('userdata');
    final token = box.get('token');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId.toString();
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price?.toString() ?? '';
    request.fields['bedrooms'] = bedrooms?.toString() ?? '';
    request.fields['bathrooms'] = bathrooms?.toString() ?? '';
    request.fields['area'] = area?.toString() ?? '';
    request.fields['property_id'] = propertyId.toString();

    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          filename: path.basename(photo.path),
        ),
      );
    }

    if (images != null) {
      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]',
            image.path,
            filename: path.basename(image.path),
          ),
        );
      }
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      print('✅ Property updated successfully');
      var respStr = await response.stream.bytesToString();
      print(respStr);
    } else {
      final respStr = await response.stream.bytesToString();
      print(
        '❌ Failed to update. Status: ${response.statusCode}, Response: $respStr',
      );
      throw Exception('Failed to update property: ${response.statusCode}');
    }
  }
}
