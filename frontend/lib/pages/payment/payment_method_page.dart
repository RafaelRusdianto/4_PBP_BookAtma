import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../services/booking_service.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int selectedPayment = -1;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'BCA Virtual Account',
      'icon': Icons.account_balance,
      'badge': '',
    },
    {
      'title': 'Mandiri Virtual Account',
      'icon': Icons.account_balance_wallet,
      'badge': '',
    },
    {
      'title': 'GoPay',
      'icon': Icons.payment,
      'badge': 'PROMO',
    },
    {
      'title': 'DANA',
      'icon': Icons.wallet,
      'badge': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Metode Pembayaran'),
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
                      'Total Harga',
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
                onPressed: selectedPayment == -1
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/waiting-payment');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.borderInput,
                  minimumSize: const Size(110, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BAYAR',
                  style: TextStyle(
                    color: AppColors.white,
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
            _PaymentAppBar(
              title: 'Pilih Metode Pembayaran',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _StepProgress(activeStep: 1),
                    const SizedBox(height: 28),
                    const Text(
                      'Metode Pembayaran Populer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) {
                        return _PaymentItem(
                          icon: paymentMethods[index]['icon'],
                          title: paymentMethods[index]['title'],
                          badge: paymentMethods[index]['badge'],
                          selected: selectedPayment == index,
                          onTap: () {
                            setState(() {
                              selectedPayment = index;
                            });

                            BookingService.setPaymentMethod(
                              paymentMethods[index]['title'],
                            );
                          },
                        );
                      },
                    ),
                    if (selectedPayment == -1)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Pilih salah satu metode pembayaran terlebih dahulu.',
                          style: TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: 12,
                          ),
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

class _PaymentAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _PaymentAppBar({
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
            icon: const Icon(Icons.close, size: 20),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int activeStep;

  const _StepProgress({
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepCircle(
          number: '1',
          text: 'Pilih Metode',
          active: activeStep >= 1,
        ),
        Expanded(
          child: _Line(active: activeStep >= 2),
        ),
        _StepCircle(
          number: '2',
          text: 'Bayar',
          active: activeStep >= 2,
        ),
        Expanded(
          child: _Line(active: activeStep >= 3),
        ),
        _StepCircle(
          number: '3',
          text: 'Selesai',
          active: activeStep >= 3,
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String number;
  final String text;
  final bool active;

  const _StepCircle({
    required this.number,
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active ? AppColors.primary : AppColors.borderInput,
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 9,
            color: active ? AppColors.primary : AppColors.placeholder,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  final bool active;

  const _Line({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: active ? AppColors.primary : AppColors.borderInput,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badge;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentItem({
    required this.icon,
    required this.title,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 58,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderInput,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (badge.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.borderInput,
            ),
          ],
        ),
      ),
    );
  }
}