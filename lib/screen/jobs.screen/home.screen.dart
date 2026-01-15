import 'package:ai_powered_app/screen/jobs.screen/job.details.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import  'package:lucide_icons_flutter/lucide_icons.dart';import '../../data/providers/jobListingProvider.dart';
import 'JobProfileShow/ProfileGet.dart';
import 'myJobScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int bottomTab = 0;
  final PageController _pageController = PageController();
  DateTime? lastBackPressTime;
  // String? userId;
  String? employerId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _loadUserId();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(jobListingsProvider);
      }
    });
  }
  // Future<void> _loadUserId() async {
  //   final box = await Hive.openBox('userdata');
  //   setState(() {
  //     userId = box.get('userName');
  //     employerId = box.get('employer_id')?.toString();
  //   });
  //   debugPrint('User Name: $userId');
  //   debugPrint('Employer ID: $employerId');
  // }




  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  Future<void> _refreshJobList() async {
    if (mounted) {
      ref.invalidate(jobListingsProvider);
      await ref.read(jobListingsProvider.future);
    }
  }
  @override
  Widget build(BuildContext context) {
    final jobsList = ref.watch(jobListingsProvider);
    final jobList = ref.watch(filteredJobListProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    jobsList.when(
      data: (allJobs) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(jobListProvider.notifier).state = allJobs;
        });
      },
      error: (e, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Fluttertoast.showToast(msg: "Failed to load jobs: $e");
        });
      },
      loading: () {},
    );

    // if (userId == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    return WillPopScope(

      onWillPop: () async {
        if (bottomTab != 0) {
          _pageController.jumpToPage(0);
          setState(() {
            bottomTab = 0;
            _refreshJobList();
          });
          return false;
        }
        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return false;
        }
        return true;
      },

      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),

        body:
        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),

          onPageChanged: (index) {
            setState(() {
              bottomTab = index;
              if (index == 0) {
                _refreshJobList();
              }
            });
          },

          children: [

            RefreshIndicator(
              onRefresh: _refreshJobList,
              color: const Color(0xFF0A66C2),
              backgroundColor: Colors.white,
              child: SizedBox.expand(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.h,
                                  horizontal: 20.w,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE6EDF2),
                                hintText: "Search your Job",
                                hintStyle: GoogleFonts.alexandria(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF030016),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              // semanticsLabel: 'Search jobs',
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryBody(
                                  name: "Computer\nEngineering",
                                  icon: LucideIcons.monitor,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Computer Engineering';
                                    debugPrint(
                                      'Selected tag: Computer Engineering',
                                    );
                                  },
                                ),
                                CategoryBody(
                                  name: "BPO\nTelecaller",
                                  icon:LucideIcons.phoneCall,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'BPO Telecalle';
                                    debugPrint('Selected tag: BPO Telecalle');
                                  },
                                ),
                                CategoryBody(
                                  name: "Sales\nExecutive\nManager",
                                 icon: LucideIcons.handshake,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Sales Executive Manager';
                                    debugPrint(
                                      'Selected tag: Sales Executive  Manager',
                                    );
                                  },
                                ),
                                CategoryBody(
                                  name: "House\nkeeping",
                                  icon: LucideIcons.sprayCan,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Housekeeping';
                                    debugPrint('Selected tag: House\nkeeping');
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryBody(
                                  name: "Bank\nExecutive\nManager",
                                  icon: LucideIcons.landmark,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Bank  Executive  Manager';
                                    debugPrint(
                                      'Selected tag: Bank  Executive  Manager',
                                    );
                                  },
                                ),
                                CategoryBody(
                                  name: "Data\nEntry\nOperator",
                                  icon: LucideIcons.keyboard,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Data Entry Operator';
                                    debugPrint(
                                      'Selected tag: Data Entry Operator',
                                    );
                                  },
                                ),
                                CategoryBody(
                                  name: "Security\nGuard",
                                  icon: LucideIcons.shieldCheck,
                                  onTap: () {
                                    print("dsnk m");
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Security Guard';
                                    debugPrint('Selected tag: Security Guard');
                                  },
                                ),
                                CategoryBody(name: "See More",
                                    icon: LucideIcons.chevronRight,
                                    onTap: () {}),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 40.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              children: [
                                RecomandedBody(
                                  onTap: () {
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = '';
                                    debugPrint('Selected tag: All');
                                  },
                                  name: 'All',
                                  bgColor:
                                      selectedTag == ''
                                          ? const Color(0xFF0A66C2)
                                          : const Color(0xFFE6EDF2),
                                  textColor:
                                      selectedTag == ''
                                          ? Colors.white
                                          : const Color(0xFF1E1E1E),
                                ),
                                SizedBox(width: 10.w),
                                RecomandedBody(
                                  onTap: () {
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Full Time';
                                    debugPrint('Selected tag: Design');
                                  },
                                  name: 'Full Time',
                                  bgColor:
                                      selectedTag == 'Full Time'
                                          ? const Color(0xFF0A66C2)
                                          : const Color(0xFFE6EDF2),
                                  textColor:
                                      selectedTag == 'Full Time'
                                          ? Colors.white
                                          : const Color(0xFF1E1E1E),
                                ),
                                SizedBox(width: 10.w),
                                RecomandedBody(
                                  onTap: () {
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Part Time';
                                    debugPrint('Selected tag: Marketing');
                                  },
                                  name: 'Part Time',
                                  bgColor:
                                      selectedTag == 'Part Time'
                                          ? const Color(0xFF0A66C2)
                                          : const Color(0xFFE6EDF2),
                                  textColor:
                                      selectedTag == 'Part Time'
                                          ? Colors.white
                                          : const Color(0xFF1E1E1E),
                                ),
                                SizedBox(width: 10.w),

                                RecomandedBody(
                                  onTap: () {
                                    ref
                                        .read(selectedTagProvider.notifier)
                                        .state = 'Remote';
                                    debugPrint('Selected tag: Remote');
                                  },
                                  name: 'Remote',
                                  bgColor:
                                      selectedTag == 'Remote'
                                          ? const Color(0xFF0A66C2)
                                          : const Color(0xFFE6EDF2),
                                  textColor:
                                      selectedTag == 'Remote'
                                          ? Colors.white
                                          : const Color(0xFF1E1E1E),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                    jobsList.when(
                      data:
                          (_) =>
                              jobList.isEmpty
                                  ? SliverToBoxAdapter(
                                    child: Center(
                                      child: Text(
                                        "No jobs found",
                                        style: GoogleFonts.alexandria(
                                          fontSize: 16.sp,
                                        ),
                                        semanticsLabel: 'No jobs found',
                                      ),
                                    ),
                                  )
                                  : SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder:
                                                      (context) =>
                                                          JobDetailsScreen(
                                                            jobList[index].jobId
                                                                .toString(),
                                                          ),
                                                ),
                                              ).then((_) => _refreshJobList());
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 24.w,
                                                right: 24.w,
                                                bottom: 20.h,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    offset: Offset(0, 10),
                                                    blurRadius: 20,
                                                    spreadRadius: 0,
                                                    color: Color.fromARGB(
                                                      12,
                                                      10,
                                                      102,
                                                      194,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(20.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40.w,
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.r,
                                                                ),
                                                            color: const Color(
                                                              0xFF0A66C2,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              "assets/rajveer.png",
                                                              color:
                                                                  Colors.white,
                                                              width: 24.w,
                                                              height: 24.h,
                                                              cacheWidth:
                                                                  (24.w *
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).devicePixelRatio)
                                                                      .round(),
                                                              cacheHeight:
                                                                  (24.h *
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).devicePixelRatio)
                                                                      .round(),
                                                              semanticLabel:
                                                                  'Company logo',
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            jobList[index]
                                                                        .title !=
                                                                    null
                                                                ? Text(
                                                                  jobList[index]
                                                                      .title!,
                                                                  style: GoogleFonts.alexandria(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                      0xFF1E1E1E,
                                                                    ),
                                                                  ),
                                                                )
                                                                : Text(
                                                                  "",
                                                                  style: GoogleFonts.alexandria(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                      0xFF1E1E1E,
                                                                    ),
                                                                  ),
                                                                ),
                                                            // Text(
                                                            //   jobList[index].company!.isNotEmpty||jobList[index].company!=null
                                                            //       ? jobList[index].company!
                                                            //       : "",
                                                            //   style: GoogleFonts.alexandria(
                                                            //     fontSize: 11.sp,
                                                            //     fontWeight: FontWeight.w500,
                                                            //     color: const Color(0xFF9A97AE),
                                                            //     letterSpacing: -0.2,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: 20.sp,
                                                          color: const Color(
                                                            0xFF9A97AE,
                                                          ),
                                                          semanticLabel:
                                                              'Job Location',
                                                        ),
                                                        SizedBox(width: 6.w),
                                                        Text(
                                                          jobList[index]
                                                                  .location!
                                                                  .isNotEmpty
                                                              ? jobList[index]
                                                                  .location!
                                                              : "",
                                                          style:
                                                              GoogleFonts.alexandria(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    const Color(
                                                                      0xFF9A97AE,
                                                                    ),
                                                                letterSpacing:
                                                                    -0.2,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.attach_money,
                                                          size: 20.sp,
                                                          color: const Color(
                                                            0xFF9A97AE,
                                                          ),
                                                          semanticLabel:
                                                              'Salary',
                                                        ),
                                                        SizedBox(width: 6.w),
                                                        Text(
                                                          (jobList[index].salaryMin !=
                                                                      null &&
                                                                  jobList[index]
                                                                          .salaryMax !=
                                                                      null)
                                                              ? "₹${jobList[index].salaryMin!.toString()} - ₹${jobList[index].salaryMax!.toString()}"
                                                              : "Salary N/A",
                                                          style:
                                                              GoogleFonts.alexandria(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    const Color(
                                                                      0xFF9A97AE,
                                                                    ),
                                                                letterSpacing:
                                                                    -0.2,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 25.h),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 69.w,
                                                          height: 28.h,
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFE6EDF2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  40.r,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              jobList[index]
                                                                      .jobType ??
                                                                  "",
                                                              style: GoogleFonts.alexandria(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    const Color(
                                                                      0xFF1E1E1E,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          width: 80.w,
                                                          height: 32.h,
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFF0A66C2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  40.r,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Apply",
                                                              style: GoogleFonts.alexandria(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }, childCount: jobList.length),
                                  ),
                      error:
                          (e, _) => SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Failed to load jobs: $e",
                                    style: GoogleFonts.alexandria(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  ElevatedButton(
                                    onPressed: _refreshJobList,
                                    child: Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      loading:
                          () => const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const MyJobApplication(),

            const ProfileGet(),

          ],
        ),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A66C2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: bottomTab,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                  setState(() {
                    bottomTab = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                selectedLabelStyle: GoogleFonts.alexandria(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
                unselectedLabelStyle: GoogleFonts.gothicA1(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.work_outline),
                    label: 'Apply Job',
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

class RecomandedBody extends StatelessWidget {
  final String name;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const RecomandedBody({
    super.key,
    required this.name,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.alexandria(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
            semanticsLabel: name,
          ),
        ),
      ),
    );
  }
}

class CategoryBody extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
   CategoryBody({super.key, required this.name, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 91.w,
        height: 105.h,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Color(0xFFFFFFFF),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 24.sp,
              color: Color(0xFF3B82F6), // blue
              // Ya gradient chahiye to ShaderMask use karo
            ),

            // Spacer(),
SizedBox(height: 10.h,),
            Text(
              name,
              // textAlign: TextAlign.left,
              style: GoogleFonts.alexandria(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E1E1E),
                height: 1.2,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
