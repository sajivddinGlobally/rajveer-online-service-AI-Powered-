/*
import 'package:ai_powered_app/screen/realEstate/rentProperty.dart';
import 'package:ai_powered_app/screen/realEstate/propertyDetail.dart';
import 'package:ai_powered_app/screen/realEstate/property.Info.page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../data/models/FetachPropertyModel.dart';
import '../../data/providers/deletePropertyProvider.dart';
import '../../data/providers/favratePostProvider.dart';
import '../../data/providers/propertiesProvider.dart';
import '../../data/providers/propertyDetail.dart';
import '../../data/providers/realStateProfileGetProvider.dart';
import '../../data/providers/recentPropertyProvider.dart';
import 'InquaryListUser.dart';
import 'ProifleGetData/profileGet.dart';
import 'PropertyBookByUser.dart';
import 'buyPropertyScreen.dart';
import 'createPropertyPage.dart';
import 'favoritesListScreen.dart';

class RealestateHomePage extends ConsumerStatefulWidget {
  const RealestateHomePage({super.key});
  @override
  ConsumerState<RealestateHomePage> createState() => _RealestateHomePageState();
}

class _RealestateHomePageState extends ConsumerState<RealestateHomePage> {
  int bottomTab = 0;
  String? role;
  final PageController _pageController = PageController();
  DateTime? lastBackPressTime;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(propertiesListProvider);
        ref.invalidate(recentListProvider);
        ref.invalidate(propertyDetailProvider);
      }
    });
  }
  // Function to load role from Hive
  Future<void> _loadRole() async {
    final box = await Hive.openBox('userdata');
    setState(() {
      role = box.get('role') ?? 'user'; // Default to 'user' if role is null
    });
  }
  @override
  Widget build(BuildContext context) {
    final jobsList = ref.watch(propertiesListProvider);
    return WillPopScope(
      onWillPop: () async {
        if (bottomTab != 0) {
          _pageController.jumpToPage(0);
          setState(() {
            bottomTab = 0;
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
        body: jobsList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (model) {
            final properties = model.properties ?? [];

            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  bottomTab = index;
                });
              },
              children: [
                HomeContent(
                  role: role,
                  properties: properties,
                ), // ✅ pass real data
                role == "agent" ? CreateProperty(-1) : UserInquiryListScreen(),
                PropertyBookByUser(),
                const ProfileGetRealState(),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(role),
      ),
    );
  }

  Widget _buildBottomNavigationBar(String? role) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF00796B),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: bottomTab,
            onTap: (index) {
              setState(() => bottomTab = index);
              _pageController.jumpToPage(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.alexandria(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.gothicA1(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: role == "agent" ? "Add property" : 'Inquiry',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  final List<Property> properties;
  final String? role; // Add role parameter
  const HomeContent({super.key, required this.properties, required this.role});
  static const String baseUrl =
      'https://matrimony.rajveerfacility.in/public/';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentListAsync = ref.watch(recentListProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(ref),
          SizedBox(height: 15.h),
          _buildPropertyCarousel(ref),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              role == "agent" ? "Recently Added" : "Recently Property",
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF030016),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          recentListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (err, stack) =>
                    Center(child: Text('Error loading recent properties')),
            data: (model) {
              final recentProperties = model.properties ?? [];
              if (recentProperties.isEmpty) {
                return const Center(
                  child: Text("No Recently Added Properties Found."),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: recentProperties.length,
                  itemBuilder: (context, index) {
                    final prop = recentProperties[index];
                    final imageUrl =
                        (prop.photo != null && prop.photo!.isNotEmpty)
                            ? "$baseUrl${prop.photo}"
                            : '';
                    return PropertyCard(
                      favorite: prop.is_favorite ?? false,
                      onFavoriteToggle: () {
                        final isFavorite = prop.is_favorite ?? false;
                        final action = isFavorite ? 'remove' : 'add';
                        ref.read(
                          favrateProvider({
                            'property_id': prop.id,
                            'action': action,
                          }),
                        );
                        ref.invalidate(propertiesListProvider);
                        ref.invalidate(recentListProvider);
                      },
                      ref: ref,
                      role: role!,
                      imageUrl: imageUrl,
                      name: prop.title ?? "Unknown",
                      price: prop.price ?? "N/A",
                      propertyId: prop.id ?? "N/A",
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const PropertyTypeButton(
          image: "assets/sale.png",
          label: "Sell Property",
        ),
        const PropertyTypeButton(
          image: "assets/rent.png",
          label: "Rent Property",
        ),
        if (role == "agent") // Use the passed role
          const PropertyTypeButton(
            image: "assets/pro.png",
            label: "Add Property",
          ),
        if (role == "buyer") // Use the passed role
          const PropertyTypeButton(
            image: "assets/rent.png",
            label: "Fabricate Property",
          ),
      ],
    );
  }
  Widget _buildHeaderSection(WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 323.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        color: const Color(0xFF00796B),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            _buildAppBar(ref),
            SizedBox(height: 16.h),
            _buildSearchField(),
            SizedBox(height: 20.h),
            _buildPropertyTypeGrid(),
          ],
        ),
      ),
    );
  }
  Widget _buildAppBar(WidgetRef ref) {
    final profileAsync = ref.watch(realStateProfileDataProvider);
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              "assets/rajveer.png",
              color: const Color(0xFF00796B),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Real Estate",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            profileAsync.when(
              data: (profile) {
                final userName =
                    profile.data?.name ??
                    'User'; // Fallback to 'User' if name is null
                return Text(
                  "Welcome $userName!",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                );
              },
              loading:
                  () => Text(
                    "Welcome...",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
              error:
                  (err, stack) => Text(
                    "Welcome Guest!",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
            ),
          ],
        ),
        const Spacer(),

      ],
    );
  }
  Widget _buildSearchField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
        hintText: "Search Property",
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white38,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Color.fromARGB(25, 255, 255, 255),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Color.fromARGB(25, 255, 255, 255),
          ),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
      ),
    );
  }
  Widget _buildPropertyCarousel(WidgetRef ref) {
    const String baseUrl = 'https://matrimony.rajveerfacility.in/public/';
    if (properties.isEmpty) {
      return const Center(child: Text("No featured properties found."));
    }
    return CarouselSlider(
      items:
          properties.map((property) {
            final String imageUrl =
                (property.photo != null && property.photo!.isNotEmpty)
                    ? "$baseUrl${property.photo}"
                    : '';
            return PropertyCarouselItem(
              role: role!,
              ref: ref,
              imagePath: imageUrl,
              title: property.title ?? '',
              location: property.location ?? '',
              price: property.price ?? '',
              badRoom: property.bedrooms?.toString() ?? '',
              area: property.area ?? '',
              propertyId: property.id ?? 0,
              favorite: property.is_favorite ?? false,
              onFavoriteToggle: () async {
                final isFavorite = property.is_favorite ?? false;
                final action = isFavorite ? 'remove' : 'add';
                try {
                  // 🔄 Wait for the favorite API action to complete
                  await ref.read(
                    favrateProvider({
                      'property_id': property.id,
                      'action': action,
                    }).future,
                  );
                  ref.invalidate(propertiesListProvider);
                  ref.invalidate(recentListProvider);
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Failed to update favorite status",
                  );
                }
              },
            );
          }).toList(),
      options: CarouselOptions(
        height: 240.h,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
      ),
    );
  }
}

class PropertyCarouselItem extends StatelessWidget {
  final String role;
  final WidgetRef ref;
  final String imagePath;
  final String title;
  final String location;
  final String price;
  final String badRoom;
  final String area;
  final int propertyId;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  PropertyCarouselItem({
    required this.role,
    required this.ref,
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.badRoom,
    required this.area,
    required this.propertyId,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern(
      'en_IN',
    ).format(double.tryParse(price) ?? 0);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PropertyDetailPage(propertyId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child:
                  (imagePath.isNotEmpty)
                      ? Image.network(
                        imagePath,
                        width: 330.w,
                        height: 240.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/image.png',
                            width: 330.w,
                            height: 240.h,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset(
                        'assets/image.png',
                        width: 330.w,
                        height: 240.h,
                        fit: BoxFit.cover,
                      ),
            ),

            /// 🏷️ Rating
            Positioned(
              left: 13.w,
              top: 13.h,
              child: Container(
                width: 100.w,
                height: 34.h,
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF4B400),
                            size: 15.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "4.5",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    if (role == "buyer")
                      InkWell(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),


            if (role == "agent")
              Positioned(
                right: 13.w,
                // top: 3.h,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                  onSelected: (value) {
                    if (value == 'update') {
                      // Navigate to Update Property Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CreateProperty(
                                propertyId, // Pass propertyId for updating
                              ),
                        ),
                      );
                    }

                    else if (value == 'delete') {

                      _deleteProperty(context, ref, propertyId.toString());
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'update',
                          child: Text(
                            'Update',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

            /// 🏘️ Bottom Info Card
            Positioned(
              bottom: 13.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                  width: 304.w,
                  height: 75.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.r),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(height: 4.h),
                       */
/* Text(
                          "₹$price",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),*//*

    Text(
    "₹$formattedPrice",
    style: GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xff9A97AE),
    ),
    ),
                        SizedBox(height: 4.h),
                        Text(
                          "$badRoom Bedroom  |  ${area} (Sq Ft)",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9A97AE),
                          ),
                        ),
                      ],
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

  void _deleteProperty(
    BuildContext context,
    WidgetRef ref,
    String propertyId,
  ) async {
    try {
      final result = await ref.read(deletePropertyProvider(propertyId).future);
      if (result) {
        // Handle successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property deleted successfully')),
        );

        ref.invalidate(propertyListProvider);

      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete property",
        gravity: ToastGravity.BOTTOM,
        toastLength:
            Toast.LENGTH_LONG, // Changed to LONG for better readability
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
class PropertyCard extends StatelessWidget {
  final WidgetRef ref;
  final String imageUrl;
  final String role;
  final String name;
  final String price;
  final propertyId;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  const PropertyCard({
    super.key,
    required this.ref,
    required this.role,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.propertyId,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern(
      'en_IN',
    ).format(double.tryParse(price) ?? 0);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(propertyId),
          ),
        );
      },

      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child:
                            imageUrl.isNotEmpty
                                ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/image.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.asset(
                                  'assets/image.png',
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Container(
                      margin: EdgeInsets.only(left: 10.h),
                      child:
                    Text(

                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis, // Text overflow ko "..." me convert karega
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1E1E1E),
                      ),
                    ),),

                    Container(
                      margin: EdgeInsets.only(left: 10.h),
                      child:
                    Text(
                      "₹$formattedPrice",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff9A97AE),
                      ),
                    ),),
                  ],
                ),

                if (role == "agent")
                  Positioned(
                    right: 13.w,
                    // top: 3.h,
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      onSelected: (value) {
                        if (value == 'update') {
                          // Navigate to Update Property Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CreateProperty(
                                    propertyId, // Pass propertyId for updating
                                  ),
                            ),
                          );
                        }

                        else if (value == 'delete') {
                          // Call Delete API
                          _deleteProperty(context, ref, propertyId.toString());
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'update',
                              child: Text(
                                'Update',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                if (role == "buyer")
                  Positioned(
                    top: 10.h,
                    left: 13.w,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: favorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProperty(
    BuildContext context,
    WidgetRef ref,
    String propertyId,
  ) async {
    try {
      final result = await ref.read(deletePropertyProvider(propertyId).future);
      if (result) {
        // Handle successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property deleted successfully')),
        );
        // Refresh the favorites list
        ref.invalidate(propertyListProvider);
        ref.invalidate(recentListProvider);
        // ref.invalidate(pe);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete property",
        gravity: ToastGravity.BOTTOM,
        toastLength:
            Toast.LENGTH_LONG, // Changed to LONG for better readability
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    }
  }
}
class PropertyTypeButton extends StatelessWidget {
  final String image;
  final String label;

  const PropertyTypeButton({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (label == "Rent Property") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentProperty()),
              );
            } else if (label == "Add Property") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProperty(-1)),
              );
            } else if (label == "Fabricate Property") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuyProperty()),
              );
            }
          },
          child: Container(
            width: 117.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              color: const Color.fromARGB(255, 51, 148, 137),
            ),
            child: Center(child: Image.asset(image)),
          ),
        ),

        SizedBox(height: 13.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
*/



import 'package:ai_powered_app/screen/realEstate/rentProperty.dart';
import 'package:ai_powered_app/screen/realEstate/propertyDetail.dart';
import 'package:ai_powered_app/screen/realEstate/property.Info.page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../data/models/FetachPropertyModel.dart';
import '../../data/providers/deletePropertyProvider.dart';
import '../../data/providers/favratePostProvider.dart';
import '../../data/providers/propertiesProvider.dart';
import '../../data/providers/propertyDetail.dart';
import '../../data/providers/realStateProfileGetProvider.dart';
import '../../data/providers/recentPropertyProvider.dart';
import 'InquaryListUser.dart';
import 'ProifleGetData/profileGet.dart';
import 'PropertyBookByUser.dart';
import 'buyPropertyScreen.dart';
import 'createPropertyPage.dart';
import 'favoritesListScreen.dart';

class RealestateHomePage extends ConsumerStatefulWidget {
  const RealestateHomePage({super.key});
  @override
  ConsumerState<RealestateHomePage> createState() => _RealestateHomePageState();
}

class _RealestateHomePageState extends ConsumerState<RealestateHomePage> {
  int bottomTab = 0;
  String? role;
  final PageController _pageController = PageController();
  DateTime? lastBackPressTime;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(propertiesListProvider);
        ref.invalidate(recentListProvider);
        ref.invalidate(propertyDetailProvider);
      }
    });
  }

  // Function to load role from Hive
  Future<void> _loadRole() async {
    final box = await Hive.openBox('userdata');
    setState(() {
      role = box.get('role') ?? 'user'; // Default to 'user' if role is null
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsList = ref.watch(propertiesListProvider);
    return WillPopScope(
      onWillPop: () async {
        if (bottomTab != 0) {
          _pageController.jumpToPage(0);
          setState(() {
            bottomTab = 0;
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
        body: jobsList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (model) {
            final properties = model.properties ?? [];
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  bottomTab = index;
                });
              },
              children: [
                HomeContent(
                  role: role,
                  properties: properties,
                ),
                role == "agent" ? CreateProperty(-1) : UserInquiryListScreen(),
                PropertyBookByUser(),
                const ProfileGetRealState(),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(role),
      ),
    );
  }

  Widget _buildBottomNavigationBar(String? role) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF00796B),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: bottomTab,
            onTap: (index) {
              setState(() => bottomTab = index);
              _pageController.jumpToPage(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.alexandria(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.gothicA1(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: role == "agent" ? "Add property" : 'Inquiry',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  final List<Property> properties;
  final String? role;
  const HomeContent({super.key, required this.properties, required this.role});
  static const String baseUrl = 'https://matrimony.rajveerfacility.in/public/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentListAsync = ref.watch(recentListProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(ref),
          SizedBox(height: 15.h),
          _buildPropertyCarousel(ref),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              role == "agent" ? "Recently Added" : "Recently Property",
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF030016),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          recentListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('No Properties Found')),
            data: (model) {
              final recentProperties = model.properties ?? [];
              if (recentProperties.isEmpty) {
                return const Center(child: Text("Recently added properties will appear here."));
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: recentProperties.length,
                  itemBuilder: (context, index) {
                    final prop = recentProperties[index];
                    final imageUrl = (prop.photo != null && prop.photo!.isNotEmpty)
                        ? "$baseUrl${prop.photo}"
                        : '';
                    return PropertyCard(
                      favorite: prop.is_favorite ?? false,
                      onFavoriteToggle: () {
                        final isFavorite = prop.is_favorite ?? false;
                        final action = isFavorite ? 'remove' : 'add';
                        ref.read(
                          favrateProvider({
                            'property_id': prop.id,
                            'action': action,
                          }),
                        );
                        ref.invalidate(propertiesListProvider);
                        ref.invalidate(recentListProvider);
                      },
                      ref: ref,
                      role: role ?? 'user',
                      imageUrl: imageUrl,
                      name: prop.title ?? "Unknown",
                      price: prop.price ?? "N/A",
                      propertyId: prop.id ?? 0,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const PropertyTypeButton(image: "assets/sale.png", label: "Sell Property"),
        const PropertyTypeButton(image: "assets/rent.png", label: "Rent Property"),
        if (role == "agent")
          const PropertyTypeButton(image: "assets/pro.png", label: "Add Property"),
        if (role == "user")
          const PropertyTypeButton(image: "assets/rent.png", label: "Favorites"),
      ],
    );
  }

  Widget _buildHeaderSection(WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 323.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        color: const Color(0xFF00796B),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            _buildAppBar(ref),
            SizedBox(height: 16.h),
            _buildSearchField(),
            SizedBox(height: 20.h),
            _buildPropertyTypeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(WidgetRef ref) {
    final profileAsync = ref.watch(realStateProfileDataProvider);
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              "assets/rajveer.png",
              color: const Color(0xFF00796B),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Real Estate",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            profileAsync.when(
              data: (profile) {
                final userName = profile.data?.name ?? 'User';
                return Text(
                  "Welcome $userName!",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                );
              },
              loading: () => Text(
                "Welcome...",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              error: (err, stack) => Text(
                "Welcome Guest!",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
        hintText: "Search Property",
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white38,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color.fromARGB(25, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Color.fromARGB(25, 255, 255, 255)),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
      ),
    );
  }

  Widget _buildPropertyCarousel(WidgetRef ref) {
    if (properties.isEmpty) {
      return const Center(child: Text("No featured properties found."));
    }
    return CarouselSlider(
      items: properties.map((property) {
        final String imageUrl = (property.photo != null && property.photo!.isNotEmpty)
            ? "$baseUrl${property.photo}"
            : '';
        return PropertyCarouselItem(
          role: role ?? 'user',
          ref: ref,
          imagePath: imageUrl,
          title: property.title ?? '',
          location: property.location ?? '',
          price: property.price ?? '',
          badRoom: property.bedrooms?.toString() ?? '',
          area: property.area ?? '',
          propertyId: property.id ?? 0,
          favorite: property.is_favorite ?? false,
          onFavoriteToggle: () async {
            final isFavorite = property.is_favorite ?? false;
            final action = isFavorite ? 'remove' : 'add';
            try {
              await ref.read(
                favrateProvider({
                  'property_id': property.id,
                  'action': action,
                }).future,
              );
              ref.invalidate(propertiesListProvider);
              ref.invalidate(recentListProvider);
            } catch (e) {
              Fluttertoast.showToast(msg: "Failed to update favorite status");
            }
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 240.h,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
      ),
    );
  }
}

class PropertyCarouselItem extends StatelessWidget {
  final String role;
  final WidgetRef ref;
  final String imagePath;
  final String title;
  final String location;
  final String price;
  final String badRoom;
  final String area;
  final int propertyId;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  const PropertyCarouselItem({
    required this.role,
    required this.ref,
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.badRoom,
    required this.area,
    required this.propertyId,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern('en_IN').format(double.tryParse(price) ?? 0);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PropertyDetailPage(propertyId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: imagePath.isNotEmpty
                  ? Image.network(
                imagePath,
                width: 330.w,
                height: 240.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/image.png', width: 330.w, height: 240.h, fit: BoxFit.cover);
                },
              )
                  : Image.asset('assets/image.png', width: 330.w, height: 240.h, fit: BoxFit.cover),
            ),
            Positioned(
              left: 13.w,
              top: 13.h,
              child: Container(
                width: 100.w,
                height: 34.h,
                child: Row(
                  children: [
                  /*  Container(
                      width: 50.w,
                      height: 34.h,
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
                            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFF1E1E1E)),
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(width: 10.w),
                    if (role == "user")
                      InkWell(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (role == "agent")
              Positioned(
                right: 13.w,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                  onSelected: (value) {
                    if (value == 'update') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProperty(propertyId),
                        ),
                      );
                    } else if (value == 'delete') {
                      _deleteProperty(context, ref, propertyId.toString());
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'update',
                      child: Text('Update', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.red)),
                    ),
                  ],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            Positioned(
              bottom: 13.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Container(
                  width: 304.w,
                  height: 75.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.r),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF1E1E1E)),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "₹$formattedPrice",
                          style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xff9A97AE)),
                        ),
                        SizedBox(height: 4.h),

                        Row(children: [
                          badRoom.toString()==""?Text(""):
                          Text(
                            "$badRoom Bedroom  | ",
                            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFF9A97AE)),
                          ),
                          Text(
                            "$area (Sq Ft)",
                            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFF9A97AE)),
                          ),
                        ],)
                      ],
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

  void _deleteProperty(BuildContext context, WidgetRef ref, String propertyId) async {
    try {
      final result = await ref.read(deletePropertyProvider(propertyId).future);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property deleted successfully')),
        );
        ref.invalidate(propertiesListProvider);
        ref.invalidate(recentListProvider);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete property",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

class PropertyCard extends StatelessWidget {
  final WidgetRef ref;
  final String imageUrl;
  final String role;
  final String name;
  final String price;
  final int propertyId;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  const PropertyCard({
    super.key,
    required this.ref,
    required this.role,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.propertyId,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern('en_IN').format(double.tryParse(price) ?? 0);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(propertyId),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/image.png', fit: BoxFit.cover);
                          },
                        )
                            : Image.asset('assets/image.png', fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.only(left: 10.h),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xff1E1E1E)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.h),
                      child: Text(
                        "₹$formattedPrice",
                        style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xff9A97AE)),
                      ),
                    ),
                  ],
                ),
                if (role == "agent")
                  Positioned(
                    right: 13.w,
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                      onSelected: (value) {
                        if (value == 'update') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateProperty(propertyId),
                            ),
                          );
                        } else if (value == 'delete') {
                          _deleteProperty(context, ref, propertyId.toString());
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'update',
                          child: Text('Update', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.red)),
                        ),
                      ],
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                  ),
                if (role == "user")
                  Positioned(
                    top: 10.h,
                    left: 13.w,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: favorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProperty(BuildContext context, WidgetRef ref, String propertyId) async {
    try {
      final result = await ref.read(deletePropertyProvider(propertyId).future);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property deleted successfully')),
        );
        ref.invalidate(propertiesListProvider);
        ref.invalidate(recentListProvider);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete property",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

class PropertyTypeButton extends StatelessWidget {
  final String image;
  final String label;

  const PropertyTypeButton({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (label == "Rent Property") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RentProperty()));
            } else if (label == "Add Property") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProperty(-1)));
            } else if (label == "Favorites") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BuyProperty()));
            }
          },
          child: Container(
            width: 117.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              color: const Color.fromARGB(255, 51, 148, 137),
            ),
            child: Center(child: Image.asset(image)),
          ),
        ),
        SizedBox(height: 13.h),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ],
    );
  }
}