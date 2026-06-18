import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../core/format_helper.dart';
import '../../constants/app_colors.dart';
import '../../models/booking_model.dart';
import '../../models/review_model.dart';
import '../../services/booking_service.dart';
import '../../services/review_service.dart';
import '../review/write_review_page.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  String _shortDate(DateTime? date) {
    if (date == null) return '-';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  String _dateRange(BookingModel booking) {
    final start = _shortDate(booking.checkInDate);
    final endDate = booking.checkOutDate;
    final end = endDate == null
        ? '-'
        : '${_shortDate(endDate)} ${endDate.year}';

    return '$start - $end';
  }

  Widget _buildOrderCard(BuildContext context, BookingModel booking) {
    final isCompleted = booking.status.toLowerCase().contains('selesai');
    final statusText = isCompleted ? 'SELESAI' : 'AKTIF';
    final statusColor = isCompleted ? AppColors.mutedText : AppColors.success;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodyText.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHotelImage(imageUrl: booking.hotel.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.hotel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(text: statusText, color: statusColor),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  booking.room.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateRange(booking),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.hotel.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                if (isCompleted)
                  _ClickableStarRating(booking: booking)
                else
                  const _TinyStarRating(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(
                            booking: booking,
                            showReviewButton: isCompleted,
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      child: Text(
                        'Lihat Detail >',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContentFromFuture(
    BuildContext context,
    Future<List<BookingModel>> future,
  ) {
    return FutureBuilder<List<BookingModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Terjadi kesalahan: ${snapshot.error}',
              style: const TextStyle(color: AppColors.mutedText),
            ),
          );
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada pesanan di bagian ini',
              style: TextStyle(color: AppColors.mutedText),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: bookings.length,
          itemBuilder: (context, index) =>
              _buildOrderCard(context, bookings[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Pesanan Saya'),
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.bodyText,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const TabBar(
                labelColor: AppColors.primaryDark,
                unselectedLabelColor: AppColors.mutedText,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: 'Pesanan Aktif'),
                  Tab(text: 'Riwayat & Ulasan'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContentFromFuture(
              context,
              BookingService.getActiveBookings(),
            ),
            _buildTabContentFromFuture(
              context,
              BookingService.getHistoryBookings(),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    super.key,
    required this.booking,
    this.showReviewButton = false,
  });

  final BookingModel booking;
  final bool showReviewButton;

  String _ticketDate(DateTime? date) {
    if (date == null) return '-';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusText = showReviewButton ? 'SELESAI' : 'AKTIF';
    final statusColor = showReviewButton
        ? AppColors.mutedText
        : AppColors.success;
    final nights = booking.displayNights <= 0 ? 1 : booking.displayNights;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.bodyText,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'E-TICKET VOUCHER',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            booking.hotel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.bodyText,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const _StarRating(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusBadge(text: statusText, color: statusColor),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 230,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      width: 136,
                      height: 136,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                        color: const Color(0xFF6E896D),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'Safe for work',
                                style: TextStyle(
                                  color: AppColors.bodyText,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: AppColors.white,
                                child: BarcodeWidget(
                                  barcode: Barcode.qrCode(),
                                  data: booking.bookingCode,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Scan',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ORDER ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  booking.bookingCode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                _LocationRow(location: booking.hotel.location),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _DateBlock(
                        title: 'CHECK-IN',
                        date: _ticketDate(booking.checkInDate),
                        subtitle: 'From 14:00',
                      ),
                    ),
                    Expanded(
                      child: _DateBlock(
                        title: 'CHECK-OUT',
                        date: _ticketDate(booking.checkOutDate),
                        subtitle: 'Before 12:00',
                        alignRight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                _StaySummary(nights: nights, roomName: booking.room.name),
                const SizedBox(height: 22),
                if (showReviewButton) ...[
                  _OrderReviewSection(booking: booking),
                  const SizedBox(height: 22),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'TOTAL PAID',
                          style: TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          FormatHelper.rupiah(booking.displayTotal),
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Show this ticket and ID card at reception for check-in.',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderHotelImage extends StatelessWidget {
  const _OrderHotelImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 84,
        height: 108,
        color: AppColors.softBlue,
        child: url == null || url.isEmpty
            ? const Icon(
                Icons.hotel_outlined,
                color: AppColors.mutedText,
                size: 28,
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.hotel_outlined,
                    color: AppColors.mutedText,
                    size: 28,
                  );
                },
              ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ClickableStarRating extends StatefulWidget {
  final BookingModel booking;

  const _ClickableStarRating({required this.booking});

  @override
  State<_ClickableStarRating> createState() => _ClickableStarRatingState();
}

class _ClickableStarRatingState extends State<_ClickableStarRating> {
  int _selectedRating = 0;
  String _existingKeterangan = '';
  ReviewModel? _existingReview;
  bool _isSaving = false;
  bool _isLoading = true;
  bool _isReviewed = false;

  @override
  void initState() {
    super.initState();
    _checkExistingReview();
  }

  Future<void> _checkExistingReview() async {
    if (widget.booking.idPembayaran <= 0) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final review = await ReviewService.getReviewByPembayaran(
        widget.booking.idPembayaran,
      );
      if (mounted) {
        setState(() {
          _existingReview = review;
          _selectedRating = review?.rating ?? 0;
          _existingKeterangan = review?.keterangan ?? '';
          _isReviewed = _hasReviewContent(review);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onStarTap(int rating) async {
    if (_isSaving || _isReviewed) return;
    setState(() {
      _selectedRating = rating;
      _isSaving = true;
    });

    final result = await ReviewService.saveRating(
      idPembayaran: widget.booking.idPembayaran,
      idHotel: widget.booking.hotel.idHotel,
      rating: rating,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result['success'] == true) {
      final reviewData = result['data'];
      final idReview = reviewData is Map
          ? _parseInt(reviewData['id_review'])
          : 0;

      if (!mounted) return;

      if (idReview <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data review tidak valid')),
        );
        return;
      }

      final submitted = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => WriteReviewPage(
            booking: widget.booking,
            rating: rating,
            idReview: idReview,
            existingKeterangan: _existingKeterangan,
          ),
        ),
      );

      if (submitted == true) {
        _checkExistingReview();
      } else if (!_hasReviewContent(_existingReview)) {
        _checkExistingReview();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan rating')),
      );
      setState(() => _selectedRating = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Row(
      children: List.generate(5, (index) {
        final starNum = index + 1;
        final isFilled = starNum <= _selectedRating;

        final starIcon = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: isFilled ? AppColors.yellow : AppColors.placeholder,
            size: 22,
          ),
        );

        // Kalo udah direview, tampilkan read-only (tanpa GestureDetector)
        if (_isReviewed) return starIcon;

        return GestureDetector(
          onTap: _isSaving ? null : () => _onStarTap(starNum),
          child: starIcon,
        );
      }),
    );
  }

  bool _hasReviewContent(ReviewModel? review) {
    if (review == null) return false;
    return (review.keterangan?.trim().isNotEmpty ?? false) ||
        review.foto.isNotEmpty;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _TinyStarRating extends StatelessWidget {
  const _TinyStarRating();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => const Icon(Icons.star, color: AppColors.yellow, size: 11),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => const Icon(Icons.star, color: AppColors.yellow, size: 13),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location.isEmpty ? '-' : location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({
    required this.title,
    required this.date,
    required this.subtitle,
    this.alignRight = false,
  });

  final String title;
  final String date;
  final String subtitle;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          date,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: AppColors.bodyText,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.mutedText, fontSize: 10),
        ),
      ],
    );
  }
}

class _StaySummary extends StatelessWidget {
  const _StaySummary({required this.nights, required this.roomName});

  final int nights;
  final String roomName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.meeting_room_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$nights Nights Stay',
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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

class _OrderReviewSection extends StatefulWidget {
  const _OrderReviewSection({required this.booking});

  final BookingModel booking;

  @override
  State<_OrderReviewSection> createState() => _OrderReviewSectionState();
}

class _OrderReviewSectionState extends State<_OrderReviewSection> {
  late Future<ReviewModel?> _reviewFuture;

  @override
  void initState() {
    super.initState();
    _reviewFuture = _fetchReview();
  }

  Future<ReviewModel?> _fetchReview() {
    if (widget.booking.idPembayaran <= 0) return Future.value(null);
    return ReviewService.getReviewByPembayaran(widget.booking.idPembayaran);
  }

  void _reloadReview() {
    setState(() {
      _reviewFuture = _fetchReview();
    });
  }

  bool _hasReviewContent(ReviewModel? review) {
    if (review == null) return false;
    return (review.keterangan?.trim().isNotEmpty ?? false) ||
        review.foto.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReviewModel?>(
      future: _reviewFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _ReviewPanel(
            title: 'Review',
            child: SizedBox(
              height: 44,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        final review = snapshot.data;
        if (!_hasReviewContent(review)) {
          return _ReviewPanel(
            title: 'Tulis Review',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Belum ada review untuk pesanan ini. Pilih rating untuk mulai menulis review.',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _ReviewStarInput(
                  booking: widget.booking,
                  existingReview: review,
                  onFinished: _reloadReview,
                ),
              ],
            ),
          );
        }

        return _ReviewPanel(
          title: 'Review Anda',
          child: _SubmittedReview(review: review!),
        );
      },
    );
  }
}

class _ReviewPanel extends StatelessWidget {
  const _ReviewPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ReviewStarInput extends StatefulWidget {
  const _ReviewStarInput({
    required this.booking,
    required this.existingReview,
    required this.onFinished,
  });

  final BookingModel booking;
  final ReviewModel? existingReview;
  final VoidCallback onFinished;

  @override
  State<_ReviewStarInput> createState() => _ReviewStarInputState();
}

class _ReviewStarInputState extends State<_ReviewStarInput> {
  late int _selectedRating;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existingReview?.rating ?? 0;
  }

  Future<void> _submitRating(int rating) async {
    if (_isSaving) return;

    setState(() {
      _selectedRating = rating;
      _isSaving = true;
    });

    final result = await ReviewService.saveRating(
      idPembayaran: widget.booking.idPembayaran,
      idHotel: widget.booking.hotel.idHotel,
      rating: rating,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result['success'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan rating')),
      );
      return;
    }

    final reviewData = result['data'];
    final idReview = reviewData is Map
        ? (_parseInt(reviewData['id_review']) ??
              widget.existingReview?.idReview)
        : widget.existingReview?.idReview;

    if (idReview == null || idReview <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data review tidak valid')));
      return;
    }

    final submitted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => WriteReviewPage(
          booking: widget.booking,
          rating: rating,
          idReview: idReview,
          existingKeterangan: widget.existingReview?.keterangan ?? '',
        ),
      ),
    );

    if (submitted == true) widget.onFinished();
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final star = index + 1;
        final selected = star <= _selectedRating;

        return GestureDetector(
          onTap: _isSaving ? null : () => _submitRating(star),
          child: Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Icon(
              selected ? Icons.star : Icons.star_border,
              color: selected ? AppColors.yellow : AppColors.placeholder,
              size: 31,
            ),
          ),
        );
      }),
    );
  }
}

class _SubmittedReview extends StatelessWidget {
  const _SubmittedReview({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final reviewText = review.keterangan?.trim();
    final photoUrls = review.foto
        .map((foto) => foto.resolvedUrl)
        .where((url) => url.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ...List.generate(5, (index) {
              final selected = index < review.rating;
              return Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(
                  selected ? Icons.star : Icons.star_border,
                  color: selected ? AppColors.yellow : AppColors.placeholder,
                  size: 19,
                ),
              );
            }),
            const SizedBox(width: 8),
            Text(
              '${review.rating}/5',
              style: const TextStyle(
                color: AppColors.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          reviewText == null || reviewText.isEmpty
              ? 'Belum ada ulasan tertulis.'
              : reviewText,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 12,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (photoUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 62,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photoUrls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    photoUrls[index],
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 62,
                      height: 62,
                      color: AppColors.border,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.mutedText,
                        size: 22,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tulis Ulasan'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.bodyText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tuliskan ulasan Anda tentang pengalaman menginap di bawah ini.',
              style: TextStyle(fontSize: 14, color: AppColors.mutedText),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Tulis ulasan...',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }
}
