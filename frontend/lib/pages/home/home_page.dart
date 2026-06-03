import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../services/hotel_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<HotelModel>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = HotelService().getRecommendedHotels(limit: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Transform.translate(
                    offset: const Offset(0, -28),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: _buildSearchBox(),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSectionHeader(),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildRecommendationList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 14,
              child: _buildBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationList() {
    return FutureBuilder<List<HotelModel>>(
      future: _recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const _RecommendationMessage(
            message: 'Gagal memuat data hotel',
          );
        }

        final hotels = snapshot.data ?? [];

        if (hotels.isEmpty) {
          return const _RecommendationMessage(
            message: 'Belum ada rekomendasi hotel',
          );
        }

        return Column(
          children: hotels.map((hotel) => _HotelCard(hotel: hotel)).toList(),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 210,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 34),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '9:30 PM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME BACK,',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                    Text(
                      'Alex Johnson',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.18),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Mau ke mana hari ini?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _SearchItem(title: 'LOKASI', value: 'Mau ke ma...'),
          _SearchItem(title: 'TANGGAL', value: 'Pilih tang...'),
          _SearchItem(title: 'TAMU &\nKAMAR', value: '2 Dewas...'),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Rekomendasi',
          style: TextStyle(
            color: AppColors.bodyText,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Icon(Icons.home_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Beranda',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.explore_outlined, color: AppColors.mutedText),
          const Icon(Icons.receipt_long_outlined, color: AppColors.mutedText),
          const Icon(Icons.person_outline, color: AppColors.mutedText),
        ],
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  const _SearchItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.bodyText,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel});

  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                color: AppColors.softBlue,
                child: _HotelImage(imageUrl: hotel.imageUrl),
              ),
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
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hotel.alamat,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (hotel.kapasitas != null) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Maks. ${hotel.kapasitas} tamu',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 17),
                const SizedBox(width: 6),
                Text(
                  hotel.avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '(Review)',
                  style: TextStyle(fontSize: 12, color: AppColors.mutedText),
                ),
                const Spacer(),
                if (hotel.hargaMulai != null)
                  Text(
                    hotel.hargaMulai!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelImage extends StatelessWidget {
  const _HotelImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const _ImagePlaceholder();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ImagePlaceholder();
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: AppColors.mutedText,
      ),
    );
  }
}

class _RecommendationMessage extends StatelessWidget {
  const _RecommendationMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.mutedText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
