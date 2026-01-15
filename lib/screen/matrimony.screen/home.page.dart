import 'dart:ui';
import 'package:ai_powered_app/data/models/MatchProfileModel.dart';
import 'package:ai_powered_app/data/providers/matchProfileBasedProvider.dart';
import 'package:ai_powered_app/screen/matrimony.screen/favourite.page.dart';
import 'package:ai_powered_app/screen/matrimony.screen/particular.home.page.dart';
import 'package:ai_powered_app/screen/matrimony.screen/profile.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/profileBasedModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/profileModel.dart';
import '../../data/providers/profileGetDataProvider.dart';
import '../../data/providers/searcProfileBased.dart';
import 'ProfileShow/basicDetail.dart';
import 'chatInbox.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int tabBottom = 0;
  bool isLocked = true;
  DateTime? lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ProfileModel>>(profileDataProvider, (previous, next) {
      if (next is AsyncData && previous != next) {
        setState(() {});
      }
    });
    ref.watch(profileDataProvider);
    final profileSearch = ref.watch(profileBasedSearchProvider);
    final matchProfileData = ref.watch(matchProfileBasedProvider);

    return WillPopScope(
      onWillPop: () async {
        if (tabBottom != 0) {
          setState(() {
            tabBottom = 0;
          });
          return false;
        }

        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
          lastBackPressTime = now;
          Fluttertoast.showToast(msg: "Press back again to exit");
          return false; // Don't exit yet
        }
        return true; // Exit app
      },

      child: Scaffold(
        backgroundColor: Color(0xFFFDF6F8),
        body:
            tabBottom == 0
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    Row(
                      children: [
                        SizedBox(width: 24.w),
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Color(0xFF97144d),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/rajveer.png",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: GoogleFonts.gothicA1(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9A97AE),
                              ),
                            ),
                            // Text(
                            //   "Thane, Maharashtra",
                            //   style: GoogleFonts.gothicA1(
                            //     fontSize: 16.sp,
                            //     fontWeight: FontWeight.w500,
                            //     color: Color(0xFF030016),
                            //   ),
                            // ),
                            ref
                                .watch(profileDataProvider)
                                .when(
                                  loading:
                                      () => Text(
                                        "Loading...",
                                        style: GoogleFonts.gothicA1(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF030016),
                                        ),
                                      ),
                                  error:
                                      (e, _) => Text(
                                        "Error: $e",
                                        style: GoogleFonts.gothicA1(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF030016),
                                        ),
                                      ),
                                  data:
                                      (profile) => Text(
                                        "${profile.data?.profile.city ?? ''}  ${profile.data?.profile.state ?? ''}",
                                        style: GoogleFonts.gothicA1(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF030016),
                                        ),
                                      ),
                                ),
                          ],
                        ),
                        Spacer(),

                        SizedBox(width: 24.w),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorColor: Color(0xFF97144d),
                              dividerColor: Color(0xFFDADADA),
                              labelColor: Color(0xFF97144d),
                              unselectedLabelColor: Color(0xFF9A97AE),
                              indicatorWeight: 2.w,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(
                                  child: Text(
                                    "For You",
                                    style: GoogleFonts.gothicA1(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Nearby",
                                    style: GoogleFonts.gothicA1(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            Expanded(
                              child: TabBarView(
                                children: [
                                  /* profileSearch.when(
                                    loading:
                                        () => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    error:
                                        (e, _) =>
                                            Center(child: Text("Error: $e")),
                                    data: (searchModel) {
                                      final List<Result>? results =
                                          searchModel.results;

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24.w,
                                          vertical: 20.h,
                                        ),
                                        child: GridView.builder(
                                          itemCount: results!.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20.w,
                                                mainAxisSpacing: 20.h,
                                                childAspectRatio: 0.95,
                                              ),
                                          itemBuilder: (context, index) {
                                            final user = results[index];
                                            return Container(
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                    child:
                                                    isLocked
                                                        ?
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (_) => PartnerPreferencePage(
                                                              user.userId.toString() ?? ""
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: index != 0
                                                          ? ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                                        child: user.photoThumbnail != null
                                                            ? Image.network(
                                                          user.photoThumbnail!,
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Image.asset(
                                                          "assets/female.png",
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                          : (user.photoThumbnail != null
                                                          ? Image.network(
                                                        user.photoThumbnail!,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )
                                                          : Image.asset(
                                                        "assets/female.png",
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )),
                                                    )


                                                        :
                                                    GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (
                                                                          _,
                                                                        ) => PartnerPreferencePage(

                                                                          user.userId.toString() ??"",

                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  user.photoThumbnail !=
                                                                          null
                                                                      ? Image.network(
                                                                        user.photoThumbnail!,
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                      )
                                                                      : Image.asset(
                                                                        "assets/female.png",
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                      ),
                                                                  Image.asset(
                                                                    "assets/femalebgimage.png",
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    height:
                                                                        double
                                                                            .infinity,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                                  Positioned(
                                                                    left: 15.w,
                                                                    top: 15.h,
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            7.w,
                                                                        vertical:
                                                                            5.h,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              6.r,
                                                                            ),
                                                                        color: Color.fromARGB(
                                                                          100,
                                                                          0,
                                                                          3,
                                                                          22,
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/loca.png",
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3.w,
                                                                          ),
                                                                          Text(
                                                                            user.location ??
                                                                                "Unknown",
                                                                            style: GoogleFonts.gothicA1(
                                                                              fontSize:
                                                                                  10.sp,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom:
                                                                        16.h,
                                                                    left: 16.w,
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          user.name ??
                                                                              "",
                                                                          style: GoogleFonts.gothicA1(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          user.age !=
                                                                                  null
                                                                              ? "${user.age} years old"
                                                                              : "",
                                                                          style: GoogleFonts.gothicA1(
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(
                                                                              0xFF9A97AE,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                  ),
                                                  // if (isLocked)

                                                 if( index != 0)
                                                    Center(
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: Colors.white,
                                                      size: 30.sp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
*/
                                  profileSearch.when(
                                    loading:
                                        () => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    error:
                                        (e, _) =>
                                            Center(child: Text("Error: $e")),
                                    data: (searchModel) {
                                      final List<Result>? results =
                                          searchModel.results;

                                      // Check if results is empty or null
                                      if (results == null || results.isEmpty) {
                                        // Default list with 6 placeholders
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24.w,
                                            vertical: 20.h,
                                          ),
                                          child: GridView.builder(
                                            itemCount:
                                                6, // Fixed length of 6 for default placeholders
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 20.w,
                                                  mainAxisSpacing: 20.h,
                                                  childAspectRatio: 0.95,
                                                ),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        15.r,
                                                      ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15.r,
                                                          ),
                                                      child: ImageFiltered(
                                                        imageFilter:
                                                            ImageFilter.blur(
                                                              sigmaX: 8,
                                                              sigmaY: 8,
                                                            ),
                                                        child: Image.asset(
                                                          "assets/female.png",
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      // Image.asset(
                                                      //   "assets/female.png", // Default image
                                                      //   width: double.infinity,
                                                      //   height: double.infinity,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                    ),
                                                    Image.asset(
                                                      "assets/femalebgimage.png",
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    // Positioned(
                                                    //   left: 15.w,
                                                    //   top: 15.h,
                                                    //   child: Container(
                                                    //     padding: EdgeInsets.symmetric(
                                                    //       horizontal: 7.w,
                                                    //       vertical: 5.h,
                                                    //     ),
                                                    //     decoration: BoxDecoration(
                                                    //       borderRadius: BorderRadius.circular(6.r),
                                                    //       color: Color.fromARGB(100, 0, 3, 22),
                                                    //     ),
                                                    //     child: Row(
                                                    //       children: [
                                                    //         // Image.asset(
                                                    //         //   "assets/loca.png",
                                                    //         //   color: Colors.white,
                                                    //         // ),
                                                    //         // SizedBox(width: 3.w),
                                                    //         // Text(
                                                    //         //   "Unknown",
                                                    //         //   style: GoogleFonts.gothicA1(
                                                    //         //     fontSize: 10.sp,
                                                    //         //     color: Colors.white,
                                                    //         //   ),
                                                    //         // ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Positioned(
                                                      bottom: 16.h,
                                                      left: 16.w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   "Unknown",
                                                          //   style: GoogleFonts.gothicA1(
                                                          //     fontSize: 14.sp,
                                                          //     fontWeight: FontWeight.w500,
                                                          //     color: Colors.white,
                                                          //   ),
                                                          // ),
                                                          Text(
                                                            "",
                                                            style:
                                                                GoogleFonts.gothicA1(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                    0xFF9A97AE,
                                                                  ),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // if (index != 0) // Apply lock icon for non-first items
                                                    Center(
                                                      child: Icon(
                                                        Icons.lock,
                                                        color: Colors.white,
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }

                                      // Original logic for non-empty results
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24.w,
                                          vertical: 20.h,
                                        ),
                                        child: GridView.builder(
                                          itemCount: results.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20.w,
                                                mainAxisSpacing: 20.h,
                                                childAspectRatio: 0.95,
                                              ),
                                          itemBuilder: (context, index) {
                                            final user = results[index];
                                            return Container(
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                    child:
                                                        isLocked
                                                            ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (
                                                                          _,
                                                                        ) => PartnerPreferencePage(
                                                                          user.userId.toString() ??
                                                                              "",
                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  index != 0
                                                                      ?
                                                                      // ImageFiltered(
                                                                      // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                                                      // child:
                                                                      user.photoThumbnail !=
                                                                              null
                                                                          ? Image.network(
                                                                            user.photoThumbnail!,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                          : Image.asset(
                                                                            "assets/female.png",
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                      // )
                                                                      : (user.photoThumbnail !=
                                                                              null
                                                                          ? Image.network(
                                                                            user.photoThumbnail!,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                          : Image.asset(
                                                                            "assets/female.png",
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                double.infinity,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                            )
                                                            : GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (
                                                                          _,
                                                                        ) => PartnerPreferencePage(
                                                                          user.userId.toString() ??
                                                                              "",
                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  user.photoThumbnail !=
                                                                          null
                                                                      ? Image.network(
                                                                        user.photoThumbnail!,
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                      )
                                                                      : Image.asset(
                                                                        "assets/female.png",
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                      ),
                                                                  Image.asset(
                                                                    "assets/femalebgimage.png",
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    height:
                                                                        double
                                                                            .infinity,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                                  Positioned(
                                                                    left: 15.w,
                                                                    top: 15.h,
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            7.w,
                                                                        vertical:
                                                                            5.h,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              6.r,
                                                                            ),
                                                                        color: Color.fromARGB(
                                                                          100,
                                                                          0,
                                                                          3,
                                                                          22,
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "assets/loca.png",
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3.w,
                                                                          ),
                                                                          Text(
                                                                            user.location ??
                                                                                "Unknown",
                                                                            style: GoogleFonts.gothicA1(
                                                                              fontSize:
                                                                                  10.sp,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom:
                                                                        16.h,
                                                                    left: 16.w,
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          user.name ??
                                                                              "",
                                                                          style: GoogleFonts.gothicA1(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          user.age !=
                                                                                  null
                                                                              ? "${user.age} years old"
                                                                              : "",
                                                                          style: GoogleFonts.gothicA1(
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(
                                                                              0xFF9A97AE,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),

                                  matchProfileData.when(
                                    loading:
                                        () => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    error:
                                        (e, _) =>
                                            Center(child: Text("Error: $e")),
                                    data: (searchModel) {
                                      final List<Match>? results =
                                          searchModel.matches;
                                      // 🔥 FIRST: EMPTY CHECK
                                      if (results == null || results.isEmpty) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Illustration (optional)
                                                SizedBox(
                                                  height: 180.h,
                                                  child: Image.network(
                                                    "https://cdn-icons-png.flaticon.com/512/4076/4076503.png",
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),

                                                SizedBox(height: 20.h),

                                                Text(
                                                  "No Matches Found Yet",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),

                                                SizedBox(height: 10.h),

                                                Text(
                                                  "Try updating your partner preferences to get better match results.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),

                                                SizedBox(height: 25.h),

                                                // Update Preference Button
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  ProfilePage(),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(
                                                        0xFF97144d,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 15.h,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Update Preferences",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 10.h),

                                                // Refresh Button
                                                TextButton(
                                                  onPressed: () {
                                                    ref.refresh(
                                                      matchProfileBasedProvider,
                                                    );
                                                  },
                                                  child: Text(
                                                    "Refresh Matches",
                                                    style: TextStyle(
                                                      color: Color(0xFF97144d),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount: results!.length,
                                        itemBuilder: (context, index) {
                                          final match = results[index];

                                          return Card(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 8.w,
                                            ),
                                            child: ListTile(
                                              leading:
                                                  match
                                                          .photoThumbnail!
                                                          .isNotEmpty
                                                      ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        child: Image.network(
                                                          match.photoThumbnail ??
                                                              "",
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                      : Image.asset(
                                                        'assets/female.png',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                              title: Text(match.name ?? ""),
                                              subtitle: Text(
                                                "${match.age ?? 'N/A'} • ${match.location ?? ""}",
                                              ),
                                              trailing: Text(
                                                match.status ?? "",
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder:
                                                        (context) =>
                                                            PartnerPreferencePage(
                                                              match.userId
                                                                  .toString(),
                                                            ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : tabBottom == 1
                ? Chatinbox()
                : tabBottom == 2
                ? FavouritePage()
                : BasicDetail(),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF97144d),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: BottomNavigationBar(
                backgroundColor:
                    Colors.transparent, // Make nav bar background transparent
                elevation: 0, // Optional: remove shadow
                currentIndex: tabBottom,
                onTap: (value) {
                  setState(() {
                    tabBottom = value;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                selectedLabelStyle: GoogleFonts.gothicA1(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
                unselectedLabelStyle: GoogleFonts.gothicA1(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Message',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    label: 'Favourite',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outlined),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
