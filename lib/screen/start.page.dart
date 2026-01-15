
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<Map<String, String>> carouselItems = [
    {
      'image': 'assets/start.png',
      'title': 'Find Your Life Partner',
      'subtitle': 'Start Your Journey to Forever',
    },
    {
      'image': 'assets/building.png',
      'title': 'Find Your Dream Home',
      'subtitle': 'Buy, Rent Or Sell Property',
    },
    {
      'image': 'assets/jobs.png',
      'title': 'Discover Your Career',
      'subtitle': 'Explore Job Opportunities',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35.h,),
            CarouselSlider(
              options: CarouselOptions(
                height: 230.h,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                viewportFraction: 0.9,
              ),
              items: carouselItems.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.w), // Increased left and right margin
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        image: DecorationImage(
                          image: AssetImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                item['title']!,
                                style: GoogleFonts.gothicA1(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                item['subtitle']!,
                                style: GoogleFonts.gothicA1(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 45.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginPage("MATRIMONY")),
                      );
                    },
                    child: FindBody(
                      title: "MATRIMONY",
                      subtitle: "FIND YOUR LIFE PARTNER",
                    ),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginPage("JOBS")),
                      );
                    },
                    child: FindBody(
                      title: "JOBS",
                      subtitle: "DISCOVER CAREER OPPORTUNITIES",
                    ),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginPage("REAL ESTATE")),
                      );
                    },
                    child: FindBody(
                      title: "REAL ESTATE",
                      subtitle: "BUY, RENT OR SELL PROPERTY",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}


class FindBody extends StatelessWidget {
  final String title;
  final String subtitle;
  const FindBody({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return
      Card(child:
      Container(
      width: 392.w,
      height: 166.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Color(0xFFEDECF5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.gothicA1(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xFF030016),
              // 
            ),
          ),

          SizedBox(height: 15.h,),
          Text(
            subtitle,
            style: GoogleFonts.gothicA1(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF716F80),
              // 
            ),
          ),
        ],
      ),
      )  );
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