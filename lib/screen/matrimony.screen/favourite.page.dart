/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/profileBasedModel.dart'; // Adjust import based on your project structure
import '../../data/providers/searcProfileBased.dart'; // Adjust import for your provider

// Mock data for demonstration (replace with actual provider data)
final mockProfiles = [
  Result(
    name: 'Priya Sharma',
    age: '28',
    height: '5ft 3in',
    city: 'Mumbai',
    state: 'Maharashtra',
    profileId: 'MH123456',
    photoThumbnail: 'https://i.imgur.com/abc123.png', // Example URL
  ),
  Result(
    name: 'Anjali Patil',
    age: '25',
    height: '5ft 5in',
    city: 'Pune',
    state: 'Maharashtra',
    profileId: 'MH789012',
    photoThumbnail: 'https://i.imgur.com/xyz789.png',
  ),
  Result(
    name: 'Sneha Deshmukh',
    age: '30',
    height: '5ft 2in',
    city: 'Nagpur',
    state: 'Maharashtra',
    profileId: 'MH345678',
    photoThumbnail: 'https://i.imgur.com/pqr456.png',
  ),
  Result(
    name: 'Riya Kulkarni',
    age: '27',
    height: '5ft 4in',
    city: 'Nashik',
    state: 'Maharashtra',
    profileId: 'MH901234',
    photoThumbnail: 'https://i.imgur.com/mno789.png',
  ),
  Result(
    name: 'Meera Joshi',
    age: '29',
    height: '5ft 6in',
    city: 'Aurangabad',
    state: 'Maharashtra',
    profileId: 'MH567890',
    photoThumbnail: 'https://i.imgur.com/stu123.png',
  ),
  Result(
    name: 'Neha More',
    age: '26',
    height: '5ft 3in',
    city: 'Thane',
    state: 'Maharashtra',
    profileId: 'MH234567',
    photoThumbnail: 'https://i.imgur.com/vwx456.png',
  ),
  Result(
    name: 'Pooja Sawant',
    age: '31',
    height: '5ft 5in',
    city: 'Kolhapur',
    state: 'Maharashtra',
    profileId: 'MH678901',
    photoThumbnail: 'https://i.imgur.com/yz123.png',
  ),
];

class UserViewedProfilesScreen extends ConsumerWidget {
  const UserViewedProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider for viewed profiles (replace with your actual provider)
    final profileSearch = ref.watch(profileBasedSearchProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFDF6F8),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildSearchFilter(),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Viewed Profiles (${profileSearch.isLoading ? 0 : mockProfiles.length})", // Update count dynamically
                style: GoogleFonts.gothicA1(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF97144d),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "The profiles viewed by you are displayed here.\nLocation: Maharashtra",
                style: GoogleFonts.gothicA1(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: profileSearch.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (searchModel) {
                // Use mockProfiles for now; replace with searchModel.results if using real API
                final profiles = mockProfiles; // searchModel.results ?? [];
                if (profiles.isEmpty) {
                  return Center(child: Text("No profiles viewed yet."));
                }
                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return ProfileCard(
                      name: profile.name ?? 'Unknown',
                      age: profile.age ?? 'N/A',
                      height: profile.height ?? 'N/A',
                      location: "${profile.city}, ${profile.state}",
                      profileId: profile.profileId ?? 'N/A',
                      isPhotoLocked: false, // Adjust based on your logic
                      imagePath: profile.photoThumbnail,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 12.w),
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name, age, height, location, profileId;
  final bool isPhotoLocked;
  final String? imagePath;

  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.location,
    required this.profileId,
    required this.isPhotoLocked,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            _buildProfileImage(),
            SizedBox(width: 12.w),
            Expanded(child: _buildProfileDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imagePath != null && imagePath!.isNotEmpty
          ? Image.network(
        imagePath!,
        width: 75.w,
        height: 75.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/female.png',
          width: 75.w,
          height: 75.w,
          fit: BoxFit.cover,
        ),
      )
          : Image.asset(
        'assets/female.png',
        width: 75.w,
        height: 75.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.gothicA1(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "Age / Height: $age, $height",
          style: GoogleFonts.gothicA1(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          location,
          style: GoogleFonts.gothicA1(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              profileId,
              style: GoogleFonts.gothicA1(
                fontSize: 12.sp,
                color: const Color(0xFF97144d),
              ),
            ),
            Row(
              children: [
                 Icon(Icons.call, color: Color(0xFF97144d), size: 20.sp),
                SizedBox(width: 6.w),
                 Icon(Icons.settings, color: Color(0xFF97144d), size: 20.sp),
                SizedBox(width: 6.w),
                 Icon(Icons.favorite_border, color: Color(0xFF97144d), size: 20.sp),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF97144d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "View Contact",
                  style: GoogleFonts.gothicA1(
                    fontSize: 14.sp,
                    color: Color(0xFFFDF6F8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ],
    );
  }
}*/

import 'dart:developer';

import 'package:ai_powered_app/data/models/favouriteListBodyModel.dart';
import 'package:ai_powered_app/data/providers/FavoritesPropertyListProvider.dart';
import 'package:ai_powered_app/data/providers/favouriteListProvider.dart';
import 'package:ai_powered_app/screen/matrimony.screen/particular.home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../data/models/profileBasedModel.dart'; // Adjust import based on your project structure
import '../../data/providers/searcProfileBased.dart'; // Adjust import for your provider

// Mock data with different names, locations, and asset images
final mockProfiles = [
  Result(
    name: 'Priya Sharma',
    age: '28',
    height: '5ft 3in',
    city: 'Mumbai',
    state: 'Maharashtra',
    profileId: 'MH123456',
    photoThumbnail: 'assets/1.png',
  ),
  Result(
    name: 'Anjali Patil',
    age: '25',
    height: '5ft 5in',
    city: 'Pune',
    state: 'Maharashtra',
    profileId: 'MH789012',
    photoThumbnail: 'assets/2.png',
  ),
  Result(
    name: 'Sneha Deshmukh',
    age: '30',
    height: '5ft 2in',
    city: 'Nagpur',
    state: 'Maharashtra',
    profileId: 'MH345678',
    photoThumbnail: 'assets/female2.png',
  ),
  Result(
    name: 'Riya Kulkarni',
    age: '27',
    height: '5ft 4in',
    city: 'Nashik',
    state: 'Maharashtra',
    profileId: 'MH901234',
    photoThumbnail: 'assets/female.png',
  ),
  Result(
    name: 'Meera Joshi',
    age: '29',
    height: '5ft 6in',
    city: 'Aurangabad',
    state: 'Maharashtra',
    profileId: 'MH567890',
    photoThumbnail: 'assets/female3.png',
  ),
  Result(
    name: 'Neha More',
    age: '26',
    height: '5ft 3in',
    city: 'Thane',
    state: 'Maharashtra',
    profileId: 'MH234567',
    photoThumbnail: 'assets/1.png', // Reusing 1.png for variety
  ),
  Result(
    name: 'Pooja Sawant',
    age: '31',
    height: '5ft 5in',
    city: 'Kolhapur',
    state: 'Maharashtra',
    profileId: 'MH678901',
    photoThumbnail: 'assets/2.png', // Reusing 2.png for variety
  ),
];

class UserViewedProfilesScreen extends ConsumerWidget {
  const UserViewedProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider for viewed profiles (replace with your actual provider)
    final profileSearch = ref.watch(profileBasedSearchProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFDF6F8),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildSearchFilter(),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Viewed Profiles (${profileSearch.isLoading ? 0 : mockProfiles.length})",
                style: GoogleFonts.gothicA1(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF97144d),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "The profiles viewed by you are displayed here.\nLocation: Maharashtra",
                style: GoogleFonts.gothicA1(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: profileSearch.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (searchModel) {
                // Use mockProfiles for now; replace with searchModel.results if using real API
                final profiles = mockProfiles; // searchModel.results ?? [];
                if (profiles.isEmpty) {
                  return Center(child: Text("No profiles viewed yet."));
                }
                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return ProfileCard(
                      name: profile.name ?? 'Unknown',
                      age: profile.age ?? 'N/A',
                      height: profile.height ?? 'N/A',
                      location: "${profile.city}, ${profile.state}",
                      profileId: profile.profileId ?? 'N/A',
                      isPhotoLocked: false,
                      imagePath: profile.photoThumbnail,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: 12.w,
                ),
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name, age, height, location, profileId;
  final bool isPhotoLocked;
  final String? imagePath;

  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.location,
    required this.profileId,
    required this.isPhotoLocked,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            _buildProfileImage(),
            SizedBox(width: 12.w),
            Expanded(child: _buildProfileDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:
          imagePath != null && imagePath!.isNotEmpty
              ? Image.asset(
                imagePath!,
                width: 75.w,
                height: 75.w,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      'assets/female.png',
                      width: 75.w,
                      height: 75.w,
                      fit: BoxFit.cover,
                    ),
              )
              : Image.asset(
                'assets/female.png',
                width: 75.w,
                height: 75.w,
                fit: BoxFit.cover,
              ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.gothicA1(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "Age / Height: $age, $height",
          style: GoogleFonts.gothicA1(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          location,
          style: GoogleFonts.gothicA1(fontSize: 12.sp, color: Colors.grey),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              profileId,
              style: GoogleFonts.gothicA1(
                fontSize: 12.sp,
                color: const Color(0xFF97144d),
              ),
            ),
            Row(
              children: [
                Icon(Icons.call, color: Color(0xFF97144d), size: 20.sp),
                SizedBox(width: 6.w),
                Icon(Icons.settings, color: Color(0xFF97144d), size: 20.sp),
                SizedBox(width: 6.w),
                Icon(
                  Icons.favorite_border,
                  color: Color(0xFF97144d),
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF97144d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "View Contact",
                  style: GoogleFonts.gothicA1(
                    fontSize: 14.sp,
                    color: Color(0xFFFDF6F8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ],
    );
  }
}

class FavouritePage extends ConsumerStatefulWidget {
  const FavouritePage({super.key});

  @override
  ConsumerState<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends ConsumerState<FavouritePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var id = box.get("user_id");
    final favouriteData = ref.watch(favouriteListProvider(id));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F8),
        elevation: 0,
        title: Text(
          "Your Favourites ❤️",
          style: GoogleFonts.gothicA1(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF030016),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // 🔍 Search Bar
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search your favourites...',
                  hintStyle: GoogleFonts.gothicA1(fontSize: 14.sp),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            Expanded(
              child: favouriteData.when(
                data: (data) {
                  final query = searchQuery.toLowerCase().trim();

                  // 🔍 Multi-field search (name + city + age)
                  final filterData =
                      data.data.where((element) {
                        final name =
                            element.favoriteUser?.name?.toLowerCase() ?? '';
                        final city =
                            element.favoriteUser?.city?.toLowerCase() ?? '';
                        final age =
                            element.favoriteUser?.age?.toLowerCase() ?? '';

                        return name.contains(query) ||
                            city.contains(query) ||
                            age.contains(query);
                      }).toList();

                  if (filterData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 60.sp,
                            color: const Color(0xFF97144d),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            query.isEmpty
                                ? "No Favourite List Yet!"
                                : "No results found for \"$searchQuery\"",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filterData.length,
                    itemBuilder: (context, index) {
                      final fav = filterData[index].favoriteUser;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) =>
                                      PartnerPreferencePage(fav.id.toString()),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFEBEE), Color(0xFFFFFFFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 🖼 Profile Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.network(
                                    fav?.photos ??
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                    width: 85.w,
                                    height: 85.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        width: 85.w,
                                        height: 85.w,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // 🧾 User Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fav?.name ?? "Unknown",
                                        style: GoogleFonts.gothicA1(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF333333),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Text(
                                            "Age: ${fav?.age ?? '--'}",
                                            style: GoogleFonts.gothicA1(
                                              fontSize: 13.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "| Gender: ${fav?.gender ?? '--'}",
                                            style: GoogleFonts.gothicA1(
                                              fontSize: 13.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.pink,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              "${fav?.city ?? ''}, ${fav?.state ?? ''}",
                                              style: GoogleFonts.gothicA1(
                                                fontSize: 13.sp,
                                                color: Colors.grey[800],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // ❤️ Icon Button
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF97144d,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // TODO: Remove from favourites action
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Color(0xFF97144d),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  log("$error\n$stackTrace");
                  return Center(
                    child: Text(
                      "Something went wrong 😕\n${error.toString()}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gothicA1(
                        fontSize: 14.sp,
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.pinkAccent,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
