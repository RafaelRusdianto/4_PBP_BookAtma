import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildOrderCard(
    BuildContext context,
    BookingModel booking,
  ) {
    final isCompleted = booking.status.toLowerCase().contains('selesai');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.hotel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.success : AppColors.softBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: isCompleted ? AppColors.white : AppColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              booking.hotel.location,
              style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check-in', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(_formatDate(booking.checkInDate ?? DateTime.now())),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check-out', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(_formatDate(booking.checkOutDate ?? DateTime.now())),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(booking: booking, showReviewButton: isCompleted),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Lihat Detail'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContentFromFuture(BuildContext context, Future<List<BookingModel>> future) {
    return FutureBuilder<List<BookingModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Terjadi kesalahan: ${snapshot.error}', style: const TextStyle(color: AppColors.mutedText)),
          );
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Text('Belum ada pesanan di bagian ini', style: const TextStyle(color: AppColors.mutedText)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(context, bookings[index]);
          },
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
            preferredSize: const Size.fromHeight(60),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                labelColor: AppColors.primaryDark,
                unselectedLabelColor: AppColors.mutedText,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Pesanan Aktif'),
                  Tab(text: 'Riwayat & Ulasan'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContentFromFuture(context, BookingService.getActiveBookings()),
            _buildTabContentFromFuture(context, BookingService.getHistoryBookings()),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.bodyText,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('E-TICKET VOUCHER', style: TextStyle(fontSize: 12, color: AppColors.mutedText)),
                const SizedBox(height: 14),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      booking.bookingCode,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Order ID ${booking.bookingCode}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _detailRow('Hotel', booking.hotel.name),
          _detailRow('Lokasi', booking.hotel.location),
          _detailRow('Check-in', _formatDate(booking.checkInDate ?? DateTime.now())),
          _detailRow('Check-out', _formatDate(booking.checkOutDate ?? DateTime.now())),
          _detailRow('Tipe Kamar', booking.room.name),
          _detailRow('Total Bayar', 'IDR ${booking.totalPayment.toString()}'),
          const SizedBox(height: 20),
          if (showReviewButton)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReviewPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Tulis Ulasan'),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 13)),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
