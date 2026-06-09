import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../services/booking_service.dart';

class WaitingPaymentPage extends StatefulWidget {
  const WaitingPaymentPage({super.key});

  @override
  State<WaitingPaymentPage> createState() => _WaitingPaymentPageState();
}

class _WaitingPaymentPageState extends State<WaitingPaymentPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Menunggu Pembayaran'),
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
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        final result = await BookingService.submitBooking();

                        if (!context.mounted) {
                          return;
                        }

                        setState(() {
                          isLoading = false;
                        });

                        if (result['success'] == true) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/voucher',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['message']?.toString() ??
                                    'Booking gagal diproses',
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.borderInput,
                  minimumSize: const Size(120, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLoading ? 'Loading...' : 'Cek Status',
                  style: const TextStyle(
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
            _AppBarTitle(
              title: 'Menunggu Pembayaran',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const _StepProgress(activeStep: 2),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Selesaikan dalam 23:59:59',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          'ORDER ID\nBA-9822104',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _VirtualAccountCard(
                      paymentMethod: booking.paymentMethod,
                    ),
                    const SizedBox(height: 22),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cara Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _HowToPay(title: 'ATM BCA'),
                    const _HowToPay(title: 'm-BCA (BCA Mobile)'),
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
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
        _StepCircle(number: '1', text: 'Pilih', active: activeStep >= 1),
        Expanded(child: _Line(active: activeStep >= 2)),
        _StepCircle(number: '2', text: 'Bayar', active: activeStep >= 2),
        Expanded(child: _Line(active: activeStep >= 3)),
        _StepCircle(number: '3', text: 'Selesai', active: activeStep >= 3),
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

class _VirtualAccountCard extends StatelessWidget {
  final String paymentMethod;

  const _VirtualAccountCard({
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance,
            color: AppColors.primary,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            paymentMethod.isEmpty ? 'Virtual Account' : paymentMethod,
            style: const TextStyle(
              color: AppColors.textDisabled,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              const Text(
                '8092 2796 3501',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'SALIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Gunakan Virtual Account ini untuk melakukan pembayaran sebelum batas waktu berakhir.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.placeholder,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowToPay extends StatelessWidget {
  final String title;

  const _HowToPay({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textDisabled,
          ),
        ],
      ),
    );
  }
}