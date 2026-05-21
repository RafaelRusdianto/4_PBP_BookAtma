import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          children: [
            // IMAGE SECTION
            Stack(
              children: [
                // IMAGE
                Container(
                  height: 190,
                  width: double.infinity,
                  color: AppColors.softBlue,

                  child: Image.network(
                    hotel.imageUrl ?? '',

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: AppColors.mutedText,
                        ),
                      );
                    },
                  ),
                ),

                // DARK OVERLAY
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,

                  child: Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),

                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // HOTEL NAME
                        Text(
                          hotel.nama,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // HOTEL LOCATION
                        Text(
                          '📍 ${hotel.alamat}',

                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // BOTTOM DETAIL
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),

              child: Row(
                children: [
                  // ROOM
                  const Icon(
                    Icons.bed_outlined,
                    size: 16,
                    color: AppColors.mutedText,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${hotel.kapasitas ?? 0} bed',

                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // GUEST
                  const Icon(
                    Icons.people_outline,
                    size: 16,
                    color: AppColors.mutedText,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${hotel.kapasitas ?? 0} Guest',

                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),

                  const Spacer(),

                  // RATING
                  const Icon(Icons.star, color: Colors.amber, size: 17),

                  Text(
                    ' ${hotel.avgRating} ',

                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),

                  // PRICE
                  Text(
                    hotel.hargaMulai ?? 'Rp -',

                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
