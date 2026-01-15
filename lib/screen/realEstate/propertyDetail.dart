/*
import 'package:ai_powered_app/screen/realEstate/property.Info.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/propertyDetail.dart';
import 'InquariesScreen.dart';

class PropertyDetailPage extends ConsumerWidget {
  final int? propertyId;
  const PropertyDetailPage(this.propertyId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the propertyDetailProvider with the propertyId
    final propertyDetailAsync = ref.watch(propertyDetailProvider(propertyId!));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: propertyDetailAsync.when(
        data: (rentModel) {
          // Assuming RentModel contains a PropertyDetailModel or similar structure
          final property = rentModel.property; // Adjust based on your RentModel structure
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      // Use property photo from API if available
                      property?.photo != null
                          ? Image.network(
                        property!.photo!,
                        width: MediaQuery.of(context).size.width,
                        height: 400.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              "assets/image.png",
                              width: MediaQuery.of(context).size.width,
                              height: 400.h,
                              fit: BoxFit.cover,
                            ),
                      )
                          : Image.asset(
                        "assets/image.png",
                        width: MediaQuery.of(context).size.width,
                        height: 400.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 20.w,
                        top: 20.h,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    SizedBox(width: 24.w),
                    Text(
                      property!.title ?? "Property Title",
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E1E1E),
                        
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 50.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star,
                              color: const Color(0xFFF4B400), size: 15.sp),
                          SizedBox(width: 3.w),
                          Text(
                            "4.5", // Replace with dynamic rating if available
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 24.w),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    SizedBox(width: 24.w),
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF9A97AE),
                      size: 18.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      property.location ?? "Unknown Location",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9A97AE),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    property.price != null ? "₹${property.price}/m" : "Price N/A",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF00796B),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    children: [
                      Container(
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: const Color(0xFFDADADA), width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            "${property.bedrooms ?? 0} Bedroom",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: const Color(0xFFDADADA), width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            "${property.bathrooms ?? 0} Bathroom",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: const Color(0xFFDADADA), width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            "${property.area ?? 'N/A'} sqft",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    "Property Description",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1E1E1E),
                      
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 15.h, right: 24.w),
                  child: Text(
                    property.description ?? "No description available",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF878599),
                      
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    "Location",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1E1E1E),
                      
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Image.asset("assets/map.png"), // Replace with dynamic map if available
                ),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            "Error: $error",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.red,
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
        onTap: () async {
      // Step 1: Select Date
      final selectedDateRaw = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      );

      if (selectedDateRaw == null) return; // If user cancels

      // Step 2: Select Time
      final now = DateTime.now();
      final initialTime = TimeOfDay(hour: now.hour, minute: now.minute);

      final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
      return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
      child: child!,
      );
      },
      );

      if (selectedTime == null) return; // If user cancels

      // Combine selected date and time
      final selectedDateTime = DateTime(
      selectedDateRaw.year,
      selectedDateRaw.month,
      selectedDateRaw.day,
      selectedTime.hour,
      selectedTime.minute,
      );

      if (selectedDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(
      "Please select a future date and time.",
      style: GoogleFonts.inter(fontSize: 14.sp),
      ),
      backgroundColor: Colors.red,
      ),
      );
      return;
      }

      // Step 3: Prepare separate date and time variables
      String selectedDate = "${selectedDateRaw.year}-${selectedDateRaw.month.toString().padLeft(2, '0')}-${selectedDateRaw.day.toString().padLeft(2, '0')}";
      String selectedTimeOnly = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

      print("📅 Selected Date: $selectedDate");
      print("⏰ Selected Time: $selectedTimeOnly");

      // Step 4: Prepare payload for API
      Map<String, dynamic> payload = {
      "date": selectedDate,
      "time": selectedTimeOnly,
      };

      // 🟢 Optional: Send to API (you can use http.post)
      // await http.post(url, body: jsonEncode(payload), headers: { ... });

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(
      "Selected: $selectedDate at ${selectedTime.format(context)}",
      style: GoogleFonts.inter(fontSize: 14.sp),
      ),
      backgroundColor: Colors.green,
      ),
      );

      }
,
        child: Container(
                  height: 74.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF00796B),
                  ),
                  child: Center(
                    child: Text(
                      "Book Now",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w), // space between buttons
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => EnquariesScreen(propertyId)),
                  );
                },
                child: Container(
                  height: 74.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF00796B),
                  ),
                  child: Center(
                    child: Text(
                      "Contact Agent",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),




    );


  }
}*/

import 'package:ai_powered_app/screen/realEstate/realEstate.home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../data/models/PropertyDetailModel.dart';
import '../../data/providers/propertyDetail.dart';
import '../../data/providers/realStateBookProperty.dart';
import 'InquariesScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PropertyDetailPage extends ConsumerStatefulWidget {
  final int? propertyId;
  const PropertyDetailPage(this.propertyId, {super.key});

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage> {

  DateTime bookingDate =  DateTime.now(); // Initialize with current date and time
  String bookingDate1 = "";
  DateTime _selectedDateTime =
      DateTime.now(); // Initialize with current date and time
  bool _isBooking = false; // To manage loading state during booking
  // Function to show Date and Time Picker and handle booking

  Future<void> _selectDateTimeAndBook(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Step 1: Select Date

    final DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00796B),
              onPrimary: Colors.white,
              surface: Color(0xFFF5F5F5),
              onSurface: Color(0xFF1E1E1E),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return; // User cancelled date picker

    // Step 2: Select Time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00796B),
              onPrimary: Colors.white,
              surface: Color(0xFFF5F5F5),
              onSurface: Color(0xFF1E1E1E),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return; // User cancelled time picker

    // Combine date and time
    final DateTime selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Check if selected date and time is in the future
    if (selectedDateTime.isBefore(DateTime.now())) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a future date and time.",
            style: GoogleFonts.inter(fontSize: 14.sp),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;

    }


    // Update state with selected date and time
    setState(() {
      _selectedDateTime = selectedDateTime;
    });


    // Step 3: Prepare booking payload
    final String selectedDate = DateFormat('yyyy-MM-dd',).format(selectedDateTime);

    final String selectedTime = DateFormat('HH:mm').format(selectedDateTime);

    final box = await Hive.openBox('userdata');
    final userId = box.get('user_id');

    final Map<String, dynamic> bookingPayload = {
      "user_id": userId.toString(),
      "property_id": widget.propertyId,
      "date": selectedDate,
      "time": selectedTime,
    };

    final Map<String, dynamic> bookDate = {
      "property_id": widget.propertyId,
      "date": selectedDate,

    };
    // Step 4: Call bookPropertyProvider
    setState(() {
      _isBooking = true; // Show loading indicator
    });

      print(bookingPayload);

    try {

      await ref.read(bookPropertyProvider(bookingPayload).future);
      await ref.read(bookDateProvider(bookDate).future);
      // Success toast is handled by the provider

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RealestateHomePage()),
      );


    } catch (e) {
      // Show error toast if API call fails
      Fluttertoast.showToast(
        msg: e.toString().replaceFirst('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }

    finally {
      setState(() {
        _isBooking = false; // Hide loading indicator
      });
    }

  }

  String? role;
  String? subRole;
  @override
  void initState() {
    super.initState();
    // Load role from Hive
    _loadRole();
    // Refresh job list when the HomeScreen is first initialized
  }

  // Function to load role from Hive
  Future<void> _loadRole() async {
    final box = await Hive.openBox('userdata');
    setState(() {
      role = box.get('role') ?? 'user'; // Default to 'user' if role is null
    });
  }




  // यह लाइन हटाएँ या कमेंट करें
// bookingDate1 = rentModel.property!.bookings![0].bookingDate.toString();

// नई तरीके से date + time combine करके format करें
  String? formattedBookingDateTime(List<Booking>? property) {
    if (property == null ||property!.isEmpty) {
      return null;
    }

    final booking =property![0];
    try {
      final date = booking.bookingDate; // "2025-12-01"
      final time = booking.bookingTime; // "13:19:00"

      // Combine date and time
      final dateTimeStr = "$date $time";
      final parsedDateTime = DateTime.parse(dateTimeStr);

      // Format: 1 December 2025, 01:19 PM
      return DateFormat('d MMMM yyyy, hh:mm a').format(parsedDateTime);
    } catch (e) {
      return "$booking.bookingDate ${ booking.bookingTime!.substring(0, 5)}"; // fallback
    }
  }


  @override
  Widget build(BuildContext context) {
    final propertyDetailAsync = ref.watch(
      propertyDetailProvider(widget.propertyId!),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: propertyDetailAsync.when(
        data: (rentModel) {
          final property = rentModel.property;

          // bookingDate=rentModel.property?.createdAt??"";
          rentModel.property!.bookings!.isNotEmpty?
          bookingDate1 = rentModel.property!.bookings![0].bookingDate.toString():SizedBox();
           // role = rentModel.property!.listedBy!.role;

           subRole = rentModel.property!.listedBy!.sellerName;

          final formattedPrice = NumberFormat.decimalPattern(
            'en_IN',
          ).format(double.tryParse(property!.price!) ?? 0);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      property.photo != null
                          ? Image.network(
                            property!.photo!,
                            width: MediaQuery.of(context).size.width,
                            height: 400.h,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  "assets/image.png",
                                  width: MediaQuery.of(context).size.width,
                                  height: 400.h,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            "assets/image.png",
                            width: MediaQuery.of(context).size.width,
                            height: 400.h,
                            fit: BoxFit.cover,
                          ),
                      Positioned(
                        left: 20.w,
                        top: 20.h,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),

                Row(
                  children: [
                    SizedBox(width: 24.w),
                    Expanded(
                      child: Text(
                        property!.title ?? "Property Title",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                    // const Spacer(),
                    // Container(
                    //   width: 50.w,
                    //   height: 24.h,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(40.r),
                    //     color: Colors.white,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(
                    //         Icons.star,
                    //         color: const Color(0xFFF4B400),
                    //         size: 15.sp,
                    //       ),
                    //       SizedBox(width: 3.w),
                    //       Text(
                    //         "4.5",
                    //         style: GoogleFonts.inter(
                    //           fontSize: 12.sp,
                    //           fontWeight: FontWeight.w500,
                    //           color: const Color(0xFF1E1E1E),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(width: 24.w),
                  ],
                ),

                SizedBox(height: 5.h),

                Row(
                  children: [
                    SizedBox(width: 24.w),
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF9A97AE),
                      size: 18.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      property.location ?? "Unknown Location",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9A97AE),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    "₹$formattedPrice",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF00796B),
                    ),
                  ),
                  // Text(
                  //   property.price != null ? "₹${property.price}" : "Price N/A",
                  //   style: GoogleFonts.inter(
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w400,
                  //     color: const Color(0xFF00796B),
                  //   ),
                  // ),
                ),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    children: [
                      property.bedrooms.toString()==""||  property.bedrooms.toString()=="null"?SizedBox():

                      Container(
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${property.bedrooms ?? 0} Bedroom",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),

                      property.bathrooms.toString()==""||  property.bathrooms.toString()=="null"?SizedBox():
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${property.bathrooms ?? 0} Bathroom",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        width: 124.w,
                        height: 39.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${property.area ?? 'N/A'} sqft",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    "Property Description",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 15.h, right: 24.w),
                  child: Text(
                    property.description ?? "No description available",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF878599),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Padding(
                //   padding: EdgeInsets.only(left: 24.w),
                //   child: Text(
                //     "Location",
                //     style: GoogleFonts.inter(
                //       fontSize: 20.sp,
                //       fontWeight: FontWeight.w400,
                //       color: const Color(0xFF1E1E1E),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 15.h),
                // Padding(
                //   padding: EdgeInsets.only(left: 24.w, right: 24.w),
                //   child: Image.asset("assets/map.png"),
                // ),
                // SizedBox(height: 20.h),

                // Display current or selected date and time
                // Padding(
                //   padding: EdgeInsets.only(left: 24.w, right: 24.w),
                //   child: Text(
                //     "Booking Date & Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime)}",
                //     style: GoogleFonts.inter(
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.w400,
                //       color: const Color(0xFF1E1E1E),
                //     ),
                //   ),
                // ),

              /*  bookingDate1!="null"&& bookingDate1!="null"?
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Booking Date & Time:"),

                      Container(
                        // width: 124.w,
                        // height: 39.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child:Text(
                            bookingDate1 != null
                                ? bookingDate1??""
                                : "Not available",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ):Text(""),*/


                // यह पूरा bloc replace करें जो अभी booking date दिखा रहा है
                if (property.bookings != null && property.bookings!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Scheduled Viewing:",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFF00796B), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 16.sp, color: Color(0xFF00796B)),
                              SizedBox(width: 8.w),
                          Text(
                            getFormattedBookingDateTime(property.bookings) ?? "Not scheduled yet",
                            style: GoogleFonts.inter(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00796B),
                            ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20.h),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Mobile Number:"),

                      Container(
                        // width: 124.w,
                        // height: 39.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFDADADA),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${property.mobileNumber ?? 0}",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 100.h),

              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Text(
                "Error: $error",
                style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.red),
              ),
            ),
      ),

      bottomSheet:

          role != "agent"

              ? Padding(
                padding: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            _isBooking
                                ? null // Disable button while booking
                                : () => _selectDateTimeAndBook(context, ref),
                        child: Container(
                          height: 74.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color:
                                _isBooking
                                    ? Colors.grey
                                    : const Color(0xFF00796B),
                          ),
                          child: Center(
                            child:
                                _isBooking
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      "Book Viewing",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) =>
                                      EnquariesScreen(widget.propertyId),
                            ),
                          );
                        },
                        child: Container(
                          height: 74.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: const Color(0xFF00796B),
                          ),
                          child: Center(
                            child: Text(

                              subRole=="agent"?

                              "Contact Agent"
                                  :
                              "Contact Owner",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

              : null,

    );
  }
  String getFormattedBookingDateTime(List<Booking>? bookings) {
    if (bookings == null || bookings.isEmpty) {
      return "Not scheduled yet";
    }

    final booking = bookings[0];

    // bookingDate DateTime है → उससे date निकालो
    final date = booking.bookingDate;
    if (date == null) return "Date not available";

    // bookingTime String है → उसे 12-hour format में बदलो
    String timeStr = booking.bookingTime ?? "";
    String formattedTime = "Time not set";

    if (timeStr.isNotEmpty && timeStr.length >= 5) {
      try {
        final parts = timeStr.split(":");
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        final period = hour >= 12 ? "PM" : "AM";
        if (hour == 0) hour = 12;
        if (hour > 12) hour -= 12;

        formattedTime = "$hour:${minute.toString().padLeft(2, '0')} $period";
      } catch (e) {
        formattedTime = timeStr.substring(0, 5); // fallback: 13:19
      }
    }

    // Final: 1 Dec 2025, 01:19 PM
    return "${DateFormat('d MMM yyyy').format(date)}, $formattedTime";
  }

}
