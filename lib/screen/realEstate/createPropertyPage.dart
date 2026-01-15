


import 'package:ai_powered_app/screen/realEstate/property.realEstate.details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/propertyDetail.dart';

final propertyTypeProvider = StateProvider<String?>((ref) => null);
final propertyListProvider = StateProvider<String?>((ref) => null);
final landTypeProvider = StateProvider<String?>((ref) => null);

final bhkProvider = StateProvider<String?>((ref) => null);
final priceControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final descriptionControllerProvider =
Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final titleControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);

class CreateProperty extends ConsumerStatefulWidget {
  final int? propertyId;
  const CreateProperty(this.propertyId, {super.key});

  @override
  ConsumerState<CreateProperty> createState() => _CreatePropertyState();
}

class _CreatePropertyState extends ConsumerState<CreateProperty> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clearFormFields();
      });
    }
  }

  void _clearFormFields() {
    ref.read(priceControllerProvider).clear();
    ref.read(titleControllerProvider).clear();
    ref.read(descriptionControllerProvider).clear();

    // Reset state providers
    ref.read(propertyTypeProvider.notifier).state = null;
    ref.read(propertyListProvider.notifier).state = null;
    ref.read(bhkProvider.notifier).state = null;
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
      if (property != null) {
        // Set the form fields with fetched data
        ref.read(propertyTypeProvider.notifier).state =
        ["Rent", "Sale"].contains(property.propertyType) ? property.propertyType : null;
        ref.read(propertyListProvider.notifier).state =
        [  "Apartment",
          "Villa",
          "Land",
          "Flat",
          "Independent House",
          "Builder Floor",
          "Farm House",
          "Studio Apartment",
          "Commercial Land",
          "Industrial Building",
          "Agricultural Land",
          "Plot",
          "Serviced Apartment",
          "Guest House",
        ].contains(property.category) ? property.category : null;
        ref.read(bhkProvider.notifier).state =
        ["1", "2", "3", "4", "5", "6"].contains(property.bhk?.toString())
            ? property.bhk?.toString()
            : null;
        ref.read(priceControllerProvider).text =
            (double.tryParse(property.price ?? '')?.toInt().toString()) ?? '';
        ref.read(titleControllerProvider).text = property.title ?? '';
        ref.read(descriptionControllerProvider).text = property.description ?? '';
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
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


  final landTypeList = [
    "Residential Plot",
    "Commercial Plot",
    "Agricultural Land",
    "Industrial Land",
  ];

  @override
  Widget build(BuildContext context) {
    final descriptionController = ref.watch(descriptionControllerProvider);
    final titleController = ref.watch(titleControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final propertyType = ["Rent", "Sale"];
    final propertyList = ref.watch(propertyListProvider);
    final selectedProperty = ref.watch(propertyListProvider);


    // final property = ["Apartment", "Villa", "Land"];
    final property = [
      "Apartment",
      "Villa",
      "Land",
      "Flat",
      "Independent House",
      "Builder Floor",
      "Farm House",
      "Studio Apartment",
      "Commercial Land",
      "Industrial Building",
      "Agricultural Land",
      "Plot",
      "Serviced Apartment",
      "Guest House",
    ];


    bool isLandCategory(String? property) {
      const landTypes = [
        "Land",
        "Commercial Land",
        "Agricultural Land",
        "Plot",
      ];
      return landTypes.contains(property);
    }



    final bhkList = ["1", "2", "3", "4", "5", "6"];
    final bhkFinalList = ref.watch(bhkProvider);
    final propertyTypeList = ref.watch(propertyTypeProvider);

    // Determine if we are in update mode
    bool isUpdateMode = widget.propertyId != null && widget.propertyId != -1;

    void validateAndNavigate() {
      if (propertyList == null && !isUpdateMode) {
        Fluttertoast.showToast(
          msg: "Please select a listing type",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (propertyTypeList == null && !isUpdateMode) {
        Fluttertoast.showToast(
          msg: "Please select a property type",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      if (isLandCategory(propertyList)) {
        if (ref.read(landTypeProvider) == null) {
          Fluttertoast.showToast(
            msg: "Please select land type",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }
      } else {
        if (bhkFinalList == null) {
          Fluttertoast.showToast(
            msg: "Please select BHK",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }
      }


      if (priceController.text.trim().trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter a price",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (titleController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter a title",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (descriptionController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter a description",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      // Navigate to PropertyRealestateDetails if all fields are valid
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => PropertyRealestateDetails(
            widget.propertyId,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                widget.propertyId != null && widget.propertyId != -1
                    ? "Update Property"
                    : "Add Property",
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF030016),
                  letterSpacing: -1.3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.propertyId != null && widget.propertyId != -1
                        ? "Update the Property Details"
                        : "Let's Start with the Basics",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A97AE),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildLabel("Property"),
              SizedBox(height: 10.h),

              BuildDropDown(
                hint: "Select Property",
                items: property,
                value: propertyList,
                onChange: isUpdateMode
                    ? null
                    : (value) {
                  ref.read(propertyListProvider.notifier).state = value;

                  // 🔥 IMPORTANT RESET LOGIC
                  if (isLandCategory(value)) {
                    ref.read(bhkProvider.notifier).state = null;
                  } else {
                    ref.read(landTypeProvider.notifier).state = null;
                  }
                },
              ),

              SizedBox(height: 15.h),
              _buildLabel("Property Type"),
              SizedBox(height: 10.h),
              BuildDropDown(
                hint: "Select Property Type",
                items: propertyType,
                value: propertyTypeList,
                onChange: isUpdateMode ? null : (value) => ref.read(propertyTypeProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),


              if (isLandCategory(selectedProperty)) ...[
                _buildLabel("Land Type"),
                SizedBox(height: 10.h),
                BuildDropDown(
                  hint: "Select Land Type",
                  items: landTypeList,
                  value: ref.watch(landTypeProvider),
                  onChange: (value) =>
                  ref.read(landTypeProvider.notifier).state = value,
                ),
              ] else ...[
                _buildLabel("BHK"),
                SizedBox(height: 10.h),
                BuildDropDown(
                  hint: "Select BHK",
                  items: bhkList,
                  value: bhkFinalList,
                  onChange: (value) =>
                  ref.read(bhkProvider.notifier).state = value,
                ),
              ],




              SizedBox(height: 15.h),
              _buildLabel("Price"),
              SizedBox(height: 10.h),
              TextField(
                 keyboardType: TextInputType.number,
                        inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  // या इससे भी आसान और आम तरीका:
  FilteringTextInputFormatter.digitsOnly,
],
                controller: priceController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Price",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Property Name"),
              SizedBox(height: 10.h),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Property Name",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Property Description"),
              SizedBox(height: 10.h),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Property Description",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: validateAndNavigate,
                child: Container(
                  width: double.infinity,
                  height: 53.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: const Color(0xFF00796B),
                  ),
                  child: Center(
                    child: Text(
                      widget.propertyId != null && widget.propertyId != -1
                          ? "Update"
                          : "Continue",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
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

}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?)? onChange; // Made onChange nullable

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF030016),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: onChange, // Use nullable onChange
    );
  }
}