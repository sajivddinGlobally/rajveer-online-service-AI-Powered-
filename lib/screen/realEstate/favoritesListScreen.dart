import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/FavoritesListModel.dart';
import '../../data/providers/FavoritesPropertyListProvider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesPropertyListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),

        title: Text(
          'My Favorites',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF00796B),
      ),
      body: favoritesAsync.when(
        data:
            (favoritesList) =>
                favoritesList.favorites!.isEmpty
                    ? const Center(child: Text('No favorites found'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: favoritesList.favorites!.length,
                      itemBuilder: (context, index) {
                        final property = favoritesList.favorites![index];
                        return FavoritePropertyCard(property: property);
                      },
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load favorites'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(favoritesPropertyListProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );

  }
}



class FavoritePropertyCard extends StatelessWidget {
  final Favorite property;

  const FavoritePropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child:
                property.mainImageUrl != null
                    ? Image.network(
                      property.mainImageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              _buildPlaceholderImage(),
                    )
                    : _buildPlaceholderImage(),
          ),
          // Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title ?? "",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1E1E),
                    ),
                    // style: const TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.location ?? "",

                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                         color: Colors.grey,
                    ),


                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${property.price!.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:   Colors.green
                    ),
                    // style: const TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.green,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
