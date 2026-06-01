import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../services/booking_service.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('E-Voucher'),
        ),
        body: const Center(
          child: Text('Data voucher belum tersedia'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 58,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                    ),
                  ),
                  const Text(
                    'E-Voucher',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Booking Berhasil',
                            style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Tunjukkan QR Code ini saat check-in',
                            style: TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.borderInput,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: BarcodeWidget(
                              barcode: Barcode.qrCode(),
                              data: booking.bookingCode,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'ID BOOKING',
                            style: TextStyle(
                              color: AppColors.placeholder,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            booking.bookingCode,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Divider(),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  booking.hotel.imageUrls.first,
                                  width: 74,
                                  height: 58,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.hotel.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                          color: AppColors.textDisabled,
                                        ),
                                        Expanded(
                                          child: Text(
                                            booking.hotel.location,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.textDisabled,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _InfoColumn(
                                        title: 'Check-in',
                                        value: FormatHelper.fullDate(
                                          booking.checkInDate,
                                        ),
                                        desc: 'Mulai 14:00',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _InfoColumn(
                                        title: 'Check-out',
                                        value: FormatHelper.fullDate(
                                          booking.checkOutDate,
                                        ),
                                        desc: 'Sebelum 12:00',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _VoucherInfoRow(
                                  icon: Icons.person_outline,
                                  title: 'Tamu Utama',
                                  value: booking.guestName,
                                ),
                                _VoucherInfoRow(
                                  icon: Icons.meeting_room_outlined,
                                  title: 'Tipe Kamar',
                                  value: booking.room.name,
                                ),
                                _VoucherInfoRow(
                                  icon: Icons.restaurant,
                                  title: 'Fasilitas',
                                  value: booking.selectedAddOns.isEmpty
                                      ? 'Room Only'
                                      : booking.selectedAddOns.join(', '),
                                  green: true,
                                ),
                                _VoucherInfoRow(
                                  icon: Icons.payments_outlined,
                                  title: 'Total Harga',
                                  value: FormatHelper.rupiah(
                                    booking.totalPayment,
                                  ),
                                  green: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _SmallInfo(
                                  title: 'ITINERARY ID',
                                  value: booking.itineraryId,
                                ),
                              ),
                              Expanded(
                                child: _SmallInfo(
                                  title: 'METODE PEMBAYARAN',
                                  value: booking.paymentMethod.isEmpty
                                      ? '-'
                                      : booking.paymentMethod,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/voucher-pdf');
                        },
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text(
                          'Unduh PDF',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.black,
                          side: const BorderSide(
                            color: AppColors.borderInput,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Jika ada kendala saat check-in, hubungi Customer Care BookAtma.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.placeholder,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final String desc;

  const _InfoColumn({
    required this.title,
    required this.value,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.placeholder,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          desc,
          style: const TextStyle(
            color: AppColors.textDisabled,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _VoucherInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool green;

  const _VoucherInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.green = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textDisabled,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: green ? AppColors.green : AppColors.black,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfo extends StatelessWidget {
  final String title;
  final String value;

  const _SmallInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.placeholder,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}