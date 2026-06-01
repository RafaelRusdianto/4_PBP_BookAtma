import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../services/booking_service.dart';

class RequestBookingPage extends StatefulWidget {
  const RequestBookingPage({super.key});

  @override
  State<RequestBookingPage> createState() => _RequestBookingPageState();
}

class _RequestBookingPageState extends State<RequestBookingPage> {
  bool breakfast = false;
  bool laundry = false;
  bool airport = false;

  int selectedRequest = -1;

  final TextEditingController noteController = TextEditingController();

  final List<String> requestOptions = [
    'Lantai Tinggi',
    'Kamar Bebas Rokok',
    'Kamar Merokok',
    'Pintu Terhubung',
  ];

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Pemesanan'),
        ),
        body: const Center(
          child: Text('Data booking belum tersedia'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
          color: AppColors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL HARGA',
                      style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      FormatHelper.rupiah(booking.totalPayment),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  BookingService.setAddOns(
                    breakfast: breakfast,
                    laundry: laundry,
                    airportPickup: airport,
                    specialRequest: selectedRequest == -1
                        ? ''
                        : requestOptions[selectedRequest],
                    note: noteController.text,
                  );

                  Navigator.pushNamed(context, '/payment-method');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(145, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lanjutkan ke\nPembayaran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _AppBarTitle(
              title: 'Detail Pemesanan',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⏰ SELESAIKAN DALAM 15:00',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _HotelSummaryCard(),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Layanan Tambahan'),
                    const SizedBox(height: 10),
                    _AddOnItem(
                      title: 'Sarapan (Breakfast)',
                      price: 'IDR 150.000 / orang',
                      selected: breakfast,
                      onTap: () {
                        setState(() {
                          breakfast = !breakfast;
                          booking.breakfast = breakfast;
                        });
                      },
                    ),
                    _AddOnItem(
                      title: 'Laundry Service',
                      price: 'Mulai dari IDR 50.000',
                      selected: laundry,
                      onTap: () {
                        setState(() {
                          laundry = !laundry;
                          booking.laundry = laundry;
                        });
                      },
                    ),
                    _AddOnItem(
                      title: 'Antar Jemput Bandara',
                      price: 'IDR 250.000 / trip',
                      selected: airport,
                      onTap: () {
                        setState(() {
                          airport = !airport;
                          booking.airportPickup = airport;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Permintaan Khusus'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        requestOptions.length,
                        (index) {
                          return _RequestChip(
                            text: requestOptions[index],
                            selected: selectedRequest == index,
                            onTap: () {
                              setState(() {
                                selectedRequest = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'CATATAN TAMBAHAN (OPSIONAL)',
                      style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      minLines: 3,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Saya akan tiba larut malam...',
                        hintStyle: const TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderInput,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _PriceCard(),
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

class _AppBarTitle extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _AppBarTitle({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 20),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _HotelSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderInput),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              booking.room.imageUrl,
              width: 82,
              height: 82,
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
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1x ${booking.room.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    Expanded(
                      child: Text(
                        ' ${booking.hotel.rating} (1,240 Review)',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${FormatHelper.shortDate(booking.checkInDate)} - ${FormatHelper.shortDate(booking.checkOutDate)} (${booking.nights} Malam)',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textDisabled,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info,
          color: AppColors.primary,
          size: 15,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _AddOnItem extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _AddOnItem({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderInput,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: selected ? AppColors.primary : AppColors.borderInput,
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _RequestChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double chipWidth = (MediaQuery.of(context).size.width - 52) / 2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: chipWidth,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderInput,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.primary : AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderInput),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: 'Harga Kamar (${booking.nights} Malam)',
            value: FormatHelper.rupiah(booking.roomTotal),
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Pajak dan Biaya Lainnya',
            value: FormatHelper.rupiah(booking.tax),
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Layanan Tambahan',
            value: FormatHelper.rupiah(booking.addOnTotal),
          ),
          const Divider(height: 24),
          _PriceRow(
            label: 'Total Pembayaran',
            value: FormatHelper.rupiah(booking.totalPayment),
            bold: true,
            blue: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool blue;

  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.blue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: blue ? AppColors.primary : AppColors.black,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}