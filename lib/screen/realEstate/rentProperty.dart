import 'package:ai_powered_app/screen/realEstate/propertyDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../data/models/rentModel.dart'; // ✅ Only use rentModel
import '../../data/providers/favratePostProvider.dart';
import '../../data/providers/propertiesProvider.dart';
import '../../data/providers/recentPropertyProvider.dart';
import '../../data/providers/rentProvider.dart';

class RentProperty extends ConsumerStatefulWidget {
  const RentProperty({super.key});

  @override
  ConsumerState<RentProperty> createState() => _RentPropertyState();
}

class _RentPropertyState extends ConsumerState<RentProperty> {
  String? role;
  Future<void> _loadRole() async {
    final box = await Hive.openBox('userdata');
    setState(() {
      role = box.get('role') ?? 'user'; // Default to 'user' if role is null
    });
  }
  @override
  void initState() {
    super.initState();
    _loadRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(rentListProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentList = ref.watch(rentListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title:  Text(
          "Rent Property",
          style: TextStyle(  fontSize: 20.sp,color: Colors.white),
        ),
      ),
      body: rentList.when(
        data: (data) {
          final rentProperties = data.properties ?? [];
          return ListView.builder(
            itemCount: rentProperties.length,
            itemBuilder: (context, index) {
              final property = rentProperties[index];
              return _buildPropertyCard(property);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    final formattedPrice = NumberFormat.decimalPattern(
      'en_IN',
    ).format(double.tryParse(property.price!) ?? 0);
    const String baseUrl = 'https://matrimony.rajveerfacility.in/public/';
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16.w),
      child:
      GestureDetector(onTap: (){
    Navigator.push(
    context,
    CupertinoPageRoute(
    builder: (context) =>  PropertyDetailPage(property.id),
    ),
    );
    },child:
      Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: (property.photo?.isNotEmpty ?? false)
                    ? Image.network(
                  '$baseUrl${property.photo}',
                  width: 500.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/image.png',
                      width: 500.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Image.asset(
                  'assets/image.png',
                  width: 500.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              ),


            Positioned(
                left: 13.w,
                top: 13.h,
                child:

                Container(child:


                Row(children: [

                  Container(
                    width: 50.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: const Color(0xFFF4B400), size: 15.sp),
                        SizedBox(width: 3.w),
                        Text(
                          "4.5",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(width: 10.h,),

                      ],
                    ),
                  ),
                  SizedBox(width: 10.h,),
                  if( role=="buyer" )
                    InkWell(
                      onTap:   () async {
                        final isFavorite = property.isFavorite ?? false;
                        final action = isFavorite ? 'remove' : 'add';

                        try {
                          // 🔄 Wait for the favorite API action to complete
                          await ref.read(
                            favrateProvider({
                              'property_id': property.id,
                              'action': action,
                            }).future,
                          );
                          // ✅ Refresh both lists after successful update
                          ref.invalidate(rentListProvider);
                          ref.invalidate(propertiesListProvider);
                          ref.invalidate(recentListProvider);
                        } catch (e) {
                          // ❌ Optional: Show error toast
                          Fluttertoast.showToast(msg: "Failed to update favorite status");
                        }
                      },

                      child: Icon(
                        property.isFavorite!  ? Icons.favorite : Icons.favorite_border,
                        color:  property.isFavorite!  ? Colors.red : Colors.grey,
                      ),
                    )
                ],),)

            ),
            Positioned(
              bottom: 13.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Card(
                  child: Container(
                    width: 304.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            property.title ?? "N/A",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(
                            "₹$formattedPrice",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff9A97AE),
                            ),
                          ),
                              Text(
                                "  /month",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9A97AE),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h,),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment. ,
                            children: [
                              Text(
                                "${property.bedrooms ?? "N/A"} Bedroom | ${property.area ?? "N/A"} (Sq Ft)",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF9A97AE),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      )   );
  }
}
