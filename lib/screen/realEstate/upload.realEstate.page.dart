import 'dart:io';
import 'package:ai_powered_app/screen/realEstate/realEstate.contactInfo.page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/providers/propertyDetail.dart';

final propertyImageProvider = StateProvider<List<File>>((ref) => []);
final propertyImageUrlsProvider = StateProvider<List<String>>((ref) => []);

class UploadRealestatePage extends ConsumerStatefulWidget {
  final int? propertyId;

  const UploadRealestatePage(this.propertyId, {super.key});

  @override
  ConsumerState<UploadRealestatePage> createState() =>
      _UploadRealestatePageState();
}

class _UploadRealestatePageState extends ConsumerState<UploadRealestatePage> {

  List<File> selectedFiles = [];
  List<String> existingImageUrls = [];
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
      if (property != null && property.images != null) {
        setState(() {
          existingImageUrls =
              property.images!
                  .map((image) => image.fullImageUrl ?? '')
                  .where((url) => url.isNotEmpty)
                  .toList();
          ref.read(propertyImageUrlsProvider.notifier).state =
              existingImageUrls;
        });
      } else {
        Fluttertoast.showToast(
          msg: "No property images found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load property images: $e",
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

  // Future<void> pickImages() async {
  //   final ImagePicker picker = ImagePicker();
  //
  //   final List<XFile> images = await picker.pickMultiImage();
  //
  //   if (images.isNotEmpty) {
  //     setState(() {
  //       selectedFiles.addAll(
  //         images.map((x) => File(x.path)).toList(),
  //       );
  //     });
  //
  //     ref.read(propertyImageProvider.notifier).state = selectedFiles;
  //   }
  // }
  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 80, // optional
    );

    if (images.isNotEmpty) {
      setState(() {
        selectedFiles.addAll(
          images.map((x) => File(x.path)).toList(),
        );
      });

      ref.read(propertyImageProvider.notifier).state = selectedFiles;
    }
  }

  /*Future<void> pickFiles() async {

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
  }*/


  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
    ref.read(propertyImageProvider.notifier).state = [...selectedFiles];
  }

  void removeExistingImage(int index) {
    setState(() {
      existingImageUrls.removeAt(index);
    });

    ref.read(propertyImageUrlsProvider.notifier).state = [...existingImageUrls];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              :

          SingleChildScrollView(

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 20.h),

                      Text(
                        widget.propertyId != null && widget.propertyId != -1
                            ? "Update Photos"
                            : "Upload Photos",
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF030016),
                          letterSpacing: -1.3,
                        ),
                      ),

                      Text(
                        widget.propertyId != null && widget.propertyId != -1
                            ? "Update photos for your property"
                            : "Tell us about your property",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9A97AE),
                        ),
                      ),

                      SizedBox(height: 20.h),

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
                      // GridView for existing images (from API)

                      if (existingImageUrls.isNotEmpty)

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Existing Photos",
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
                              itemCount: existingImageUrls.length,
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        child: Image.network(
                                          existingImageUrls[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Center(
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => removeExistingImage(index),
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
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
                        onTap: () {
                          if (selectedFiles.isNotEmpty ||
                              existingImageUrls.isNotEmpty) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder:
                                    (context) => RealestateContactinfoPage(
                                      widget.propertyId, // Pass propertyId
                                    ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please upload at least one photo.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },

                        child: Container(
                          width: double.infinity,
                          height: 53.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: const Color(0xFF00796B),
                          ),
                          child: Center(
                            child: Text(
                              widget.propertyId != null &&
                                      widget.propertyId != -1
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

                      SizedBox(height: 20.h),




                    ],
                  ),
                ),
              ),
    );
  }


}
