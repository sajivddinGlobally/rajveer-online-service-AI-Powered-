import 'dart:developer';
import 'dart:io';
import 'package:ai_powered_app/core/network/api.state.dart';
import 'package:ai_powered_app/core/utils/preety.dio.dart';
import 'package:ai_powered_app/data/models/PropertyDetailModel.dart' hide Image;
import 'package:ai_powered_app/data/models/deletePhotoBodyModel.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../data/providers/profileGetDataProvider.dart';
import '../../data/providers/uploadFile.dart';
import 'location.lifeStyle.page.dart';

final propertyImageProvider = StateProvider<List<File>>((ref) => []);
final propertyImageUrlsProvider = StateProvider<List<String>>((ref) => []);

class UploadPhotoPage extends ConsumerStatefulWidget {
  const UploadPhotoPage({super.key});
  @override
  ConsumerState<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends ConsumerState<UploadPhotoPage> {
  List<File> selectedFiles = [];
  bool isLoading = false;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        selectedFiles.addAll(
          result.paths
              .where((path) => path != null)
              .map((path) => File(path!))
              .toList(),
        );
      });
      ref.read(propertyImageProvider.notifier).state = selectedFiles;
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
    ref.read(propertyImageProvider.notifier).state = [...selectedFiles];
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      profileAsync.when(
                        data: (profile) {
                          List<String> oldPhotos =
                              profile.data.photos
                                  .where((photo) => photo is String)
                                  .cast<String>()
                                  .toList() ??
                              [];

                          return oldPhotos.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Previously Uploaded Photos",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF030016),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: oldPhotos.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 20.w,
                                          mainAxisSpacing: 20.h,
                                          childAspectRatio: 200 / 190,
                                        ),
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Colors.grey[300],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                int currentIndex =
                                                    0; // since you’re showing only one image here
                                                final PageController
                                                controller = PageController(
                                                  initialPage: currentIndex,
                                                );

                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      child: StatefulBuilder(
                                                        builder: (
                                                          context,
                                                          setState,
                                                        ) {
                                                          return Stack(
                                                            children: [
                                                              PhotoViewGallery.builder(
                                                                itemCount:
                                                                    oldPhotos
                                                                        .length,
                                                                pageController:
                                                                    controller, // ✅ important
                                                                backgroundDecoration:
                                                                    const BoxDecoration(
                                                                      color:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                builder: (
                                                                  context,
                                                                  i,
                                                                ) {
                                                                  return PhotoViewGalleryPageOptions(
                                                                    imageProvider:
                                                                        NetworkImage(
                                                                          oldPhotos[i], // ✅ show the actual photo
                                                                        ),
                                                                    minScale:
                                                                        PhotoViewComputedScale
                                                                            .contained,
                                                                    maxScale:
                                                                        PhotoViewComputedScale
                                                                            .covered *
                                                                        3,
                                                                    heroAttributes:
                                                                        PhotoViewHeroAttributes(
                                                                          tag:
                                                                              oldPhotos[i],
                                                                        ),
                                                                  );
                                                                },
                                                                onPageChanged: (
                                                                  i,
                                                                ) {
                                                                  setState(() {
                                                                    currentIndex =
                                                                        i;
                                                                  });
                                                                },
                                                              ),
                                                              Positioned(
                                                                top: 10,
                                                                left: 10,
                                                                right: 10,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    IconButton(
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color:
                                                                            Colors.white,
                                                                        size:
                                                                            28,
                                                                      ),
                                                                      onPressed:
                                                                          () => Navigator.pop(
                                                                            context,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      "${currentIndex + 1} / ${oldPhotos.length}",
                                                                      style: const TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          48.w,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: Image.network(
                                                  oldPhotos[index],
                                                  width: 200.w,
                                                  height: 190.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Image.asset(
                                                        'assets/placeholder.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -8,
                                            right: -5,
                                            child: InkWell(
                                              onTap: () async {
                                                final confirm = await showDialog<
                                                  bool
                                                >(
                                                  context: context,
                                                  builder:
                                                      (_) => AlertDialog(
                                                        title: const Text(
                                                          'Delete Photo?',
                                                        ),
                                                        content: const Text(
                                                          'Are you sure you want to delete this photo?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                      false,
                                                                    ),
                                                            child: const Text(
                                                              'Cancel',
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                      true,
                                                                    ),
                                                            child: const Text(
                                                              'Delete',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );

                                                if (confirm == true) {
                                                  final photoUrl =
                                                      profile
                                                          .data
                                                          .photos[index];

                                                  final relativePath = photoUrl
                                                      .replaceAll(
                                                        "https://matrimony.rajveerfacility.in/public/",
                                                        "",
                                                      );

                                                  final userId =
                                                      Hive.box('userdata')
                                                          .get('user_id')
                                                          .toString();

                                                  final body =
                                                      DeletePhotoBodyModel(
                                                        photos: [relativePath],
                                                      );

                                                  try {
                                                    final service =
                                                        APIStateNetwork(
                                                          createDio(),
                                                        );
                                                    final response =
                                                        await service
                                                            .deletePhoto(
                                                              userId,
                                                              body,
                                                            );

                                                    if (response.status ==
                                                        true) {
                                                      Fluttertoast.showToast(
                                                        msg: response.message,
                                                      );
                                                      ref.invalidate(
                                                        profileDataProvider,
                                                      );
                                                      setState(() {
                                                        oldPhotos.removeAt(
                                                          index,
                                                        );
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Failed to delete photo :${response.message}",
                                                      );
                                                    }
                                                  } catch (e, st) {
                                                    log(
                                                      "${e.toString()}/n ${st.toString()}",
                                                    );
                                                    Fluttertoast.showToast(
                                                      msg: "Api Error :$e",
                                                    );
                                                  }
                                                }

                                                // final photoUrl =
                                                //     profile.data.photos[index];
                                                // final relativePath = photoUrl
                                                //     .replaceAll(
                                                //       "https://matrimony.rajveerfacility.in/public/",
                                                //       "",
                                                //     );
                                                // final userId =
                                                //     Hive.box(
                                                //       'userdata',
                                                //     ).get('user_id').toString();
                                                // final body =
                                                //     DeletePhotoBodyModel(
                                                //       photos: [relativePath],
                                                //     );
                                                // try {
                                                //   final service =
                                                //       APIStateNetwork(
                                                //         createDio(),
                                                //       );
                                                //   final response = await service
                                                //       .deletePhoto(
                                                //         userId,
                                                //         body,
                                                //       );
                                                //   if (response.status == true) {
                                                //     Fluttertoast.showToast(
                                                //       msg: response.message,
                                                //     );
                                                //     ref.invalidate(
                                                //       profileDataProvider,
                                                //     );
                                                //     setState(() {
                                                //       oldPhotos.removeAt(index);
                                                //     });
                                                //   } else {
                                                //     Fluttertoast.showToast(
                                                //       msg:
                                                //           "Failed to delete photo :${response.message}",
                                                //     );
                                                //   }
                                                // } catch (e, st) {
                                                //   log(
                                                //     "${e.toString()}/n ${st.toString()}",
                                                //   );
                                                //   Fluttertoast.showToast(
                                                //     msg: "Api Error :$e",
                                                //   );
                                                // }
                                              },
                                              child: Container(
                                                width: 28.w,
                                                height: 28.h,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              )
                              : const SizedBox.shrink();
                        },
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (error, stack) => Text(
                              "Error loading photos: $error",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF030016),
                              ),
                            ),
                      ),
                      // Upload Button
                      GestureDetector(
                        onTap: pickFiles,
                        child: Container(
                          width: double.infinity,
                          height: 134.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: const Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_upload_outlined,
                                size: 30.sp,
                                color: const Color(0xFFA95C68),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Upload your Photos",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9A97AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // GridView for newly selected files
                      if (selectedFiles.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              "Newly Uploaded Photos",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF030016),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedFiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: Colors.grey[300],
                                      ),
                                      child: ClipRect(
                                        // borderRadius: BorderRadius.circular(10.r),
                                        child: Image.file(
                                          selectedFiles[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => removeFile(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          bool hasExistingPhotos = false;

                          ref
                              .read(profileDataProvider)
                              .maybeWhen(
                                data: (profile) {
                                  hasExistingPhotos =
                                      profile.data.photos?.isNotEmpty ?? false;
                                },
                                orElse: () => null,
                              );

                          // ✅ Unified validation: At least 1 image must exist
                          if (!hasExistingPhotos && selectedFiles.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please upload at least one photo before continuing!",
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          try {
                            // Upload only if new files are selected
                            if (selectedFiles.isNotEmpty) {
                              await ref.read(
                                uploadProfilePhotosProvider(
                                  selectedFiles,
                                ).future,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Photos uploaded successfully!",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Upload failed: $e")),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const LocationLifestylePage(),
                            ),
                          );
                        },

                        child: Container(
                          width: double.infinity,
                          height: 53.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: const Color(0xFF97144d),
                          ),
                          child: Center(
                            child:
                                isLoading
                                    ? SizedBox(
                                      width: 24.sp,
                                      height: 24.sp,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Continue",
                                      style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
    );
  }
}
