import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../models/review_model.dart';
import '../../services/review_service.dart';

class AllReviewsPage extends StatefulWidget {
  final HotelModel hotel;

  const AllReviewsPage({super.key, required this.hotel});

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  late final Future<List<ReviewModel>> _reviewsFuture;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewService.getReviewsByHotel(widget.hotel.idHotel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: FutureBuilder<List<ReviewModel>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          final reviews = snapshot.data ?? [];
          final filteredReviews = _selectedRating == 0
              ? reviews
              : reviews
                    .where((review) => review.rating == _selectedRating)
                    .toList();

          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    _Header(onBack: () => Navigator.pop(context)),
                    Expanded(
                      child: snapshot.connectionState != ConnectionState.done
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : snapshot.hasError
                          ? _MessageState(
                              icon: Icons.error_outline,
                              message: 'Gagal memuat review',
                              detail: snapshot.error.toString(),
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 158),
                                      _RatingFilters(
                                        selectedRating: _selectedRating,
                                        onChanged: (rating) {
                                          setState(() {
                                            _selectedRating = rating;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  ),
                                ),
                                if (filteredReviews.isEmpty)
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: _MessageState(
                                      icon: Icons.rate_review_outlined,
                                      message: _selectedRating == 0
                                          ? 'Belum ada review untuk hotel ini'
                                          : 'Belum ada review $_selectedRating bintang',
                                    ),
                                  )
                                else
                                  SliverPadding(
                                    padding: const EdgeInsets.fromLTRB(
                                      22,
                                      0,
                                      22,
                                      24,
                                    ),
                                    sliver: SliverList.separated(
                                      itemCount: filteredReviews.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(height: 16),
                                      itemBuilder: (context, index) {
                                        return _ReviewItemCard(
                                          review: filteredReviews[index],
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 98,
                left: 22,
                right: 22,
                child: _RatingSummaryCard(reviews: reviews),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 113,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Reviews & Ratings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  final List<ReviewModel> reviews;

  const _RatingSummaryCard({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final average = reviews.isEmpty
        ? 0.0
        : reviews.fold<int>(0, (sum, review) => sum + review.rating) /
              reviews.length;
    final counts = <int, int>{
      for (int rating = 1; rating <= 5; rating++)
        rating: reviews.where((review) => review.rating == rating).length,
    };
    final maxCount = counts.values.fold<int>(
      0,
      (max, count) => count > max ? count : max,
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.fromLTRB(30, 18, 24, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  average.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 5),
                const _StarRow(size: 18, rating: 5),
                const SizedBox(height: 12),
                Text(
                  '${reviews.length} Reviews',
                  style: const TextStyle(
                    color: Color(0xFF9AA8BD),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final rating = 5 - index;
                final count = counts[rating] ?? 0;
                final progress = maxCount == 0 ? 0.0 : count / maxCount;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _RatingBar(rating: rating, progress: progress),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int rating;
  final double progress;

  const _RatingBar({required this.rating, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 12,
          child: Text(
            '$rating',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFF0F3F6),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingFilters extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onChanged;

  const _RatingFilters({required this.selectedRating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final rating = index == 0 ? 0 : 6 - index;
          final selected = selectedRating == rating;
          return _FilterChipButton(
            selected: selected,
            label: rating == 0 ? 'All Reviews' : '$rating',
            showStar: rating != 0,
            onTap: () => onChanged(rating),
          );
        },
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final bool selected;
  final String label;
  final bool showStar;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.selected,
    required this.label,
    required this.showStar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: showStar ? 18 : 20,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE8EEF5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.black,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (showStar) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star, color: AppColors.accent, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewItemCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewItemCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final userName = review.user?.nama.trim().isNotEmpty == true
        ? review.user!.nama.trim()
        : 'Anonymous';
    final photoUrls = review.foto
        .map((foto) => foto.resolvedUrl)
        .where((url) => url.isNotEmpty)
        .toList();
    final reviewText = review.keterangan?.trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewerAvatar(user: review.user, name: userName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(review.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF9AA8BD),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StarRow(size: 15, rating: review.rating),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            reviewText == null || reviewText.isEmpty
                ? 'Memberikan rating ${review.rating}/5.'
                : reviewText,
            style: const TextStyle(
              color: Color(0xFF6F7F93),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
          if (photoUrls.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photoUrls.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      photoUrls[index],
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 74,
                        height: 74,
                        color: const Color(0xFFEAF0F7),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.placeholder,
                          size: 26,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return '';
    }
  }
}

class _ReviewerAvatar extends StatelessWidget {
  final ReviewUser? user;
  final String name;

  const _ReviewerAvatar({required this.user, required this.name});

  @override
  Widget build(BuildContext context) {
    final profileUrl = user?.resolvedFotoProfil;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 19,
      backgroundColor: const Color(0xFFE6ECF4),
      backgroundImage: profileUrl == null || profileUrl.isEmpty
          ? null
          : NetworkImage(profileUrl),
      child: profileUrl == null || profileUrl.isEmpty
          ? Text(
              initial,
              style: const TextStyle(
                color: Color(0xFF9AA8BD),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
    );
  }
}

class _StarRow extends StatelessWidget {
  final double size;
  final int rating;

  const _StarRow({required this.size, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star,
          color: index < rating ? AppColors.accent : const Color(0xFFE5ECF3),
          size: size,
        );
      }),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? detail;

  const _MessageState({required this.icon, required this.message, this.detail});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.placeholder, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.placeholder,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
