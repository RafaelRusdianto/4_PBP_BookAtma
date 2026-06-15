import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int _remainingSeconds = 600; // 10 menit = 600 detik
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final menit = seconds ~/ 60;
    final detik = seconds % 60;
    return '${menit.toString().padLeft(2, '0')}:${detik.toString().padLeft(2, '0')}';
  }

  List<Widget> _paymentInstructions(String method) {
    switch (method) {
      case 'BCA Virtual Account':
        return [
          const _HowToPay(
            title: 'ATM BCA',
            steps:
                '1. Masukkan kartu ATM BCA dan PIN\n'
                '2. Pilih menu "Transaksi Lainnya"\n'
                '3. Pilih menu "Transfer"\n'
                '4. Pilih "Ke Rekening BCA Virtual Account"\n'
                '5. Masukkan nomor Virtual Account: 8092 2796 3501\n'
                '6. Ikuti instruksi hingga selesai',
          ),
          const _HowToPay(
            title: 'm-BCA (BCA Mobile)',
            steps:
                '1. Buka aplikasi BCA Mobile dan login\n'
                '2. Pilih menu "m-Transfer"\n'
                '3. Pilih "BCA Virtual Account"\n'
                '4. Masukkan nomor Virtual Account: 8092 2796 3501\n'
                '5. Konfirmasi dan masukkan PIN\n'
                '6. Pembayaran selesai',
          ),
          const _HowToPay(
            title: 'Internet Banking BCA (KlikBCA)',
            steps:
                '1. Login ke KlikBCA (klikbca.com)\n'
                '2. Pilih menu "Transfer Dana"\n'
                '3. Pilih "Transfer ke BCA Virtual Account"\n'
                '4. Masukkan nomor Virtual Account: 8092 2796 3501\n'
                '5. Masukkan jumlah pembayaran yang sesuai\n'
                '6. Konfirmasi dan masukkan Respon Key Appli\n'
                '7. Pembayaran selesai',
          ),
        ];
      case 'Mandiri Virtual Account':
        return [
          const _HowToPay(
            title: 'ATM Mandiri',
            steps:
                '1. Masukkan kartu ATM Mandiri dan PIN\n'
                '2. Pilih menu "Bayar/Beli"\n'
                '3. Pilih "Multipayment"\n'
                '4. Cari dan pilih "Mandiri Virtual Account"\n'
                '5. Masukkan nomor Virtual Account: 8092 2796 3501\n'
                '6. Konfirmasi pembayaran',
          ),
          const _HowToPay(
            title: 'Livin by Mandiri',
            steps:
                '1. Buka aplikasi Livin by Mandiri\n'
                '2. Pilih menu "Pembayaran"\n'
                '3. Pilih "Virtual Account"\n'
                '4. Masukkan nomor Virtual Account: 8092 2796 3501\n'
                '5. Masukkan nominal pembayaran\n'
                '6. Konfirmasi dan masukkan PIN\n'
                '7. Pembayaran selesai',
          ),
        ];
      case 'GoPay':
        return [
          const _HowToPay(
            title: 'Aplikasi Gojek',
            steps:
                '1. Buka aplikasi Gojek\n'
                '2. Pilih menu "GoPay"\n'
                '3. Pilih "Bayar" atau "Top Up"\n'
                '4. Pilih "Pembayaran Merchant"\n'
                '5. Scan QR Code yang ditampilkan\n'
                '6. Masukkan jumlah pembayaran\n'
                '7. Konfirmasi dan masukkan PIN GoPay\n'
                '8. Pembayaran berhasil',
          ),
          const _HowToPay(
            title: 'GoPay via QRIS',
            steps:
                '1. Buka aplikasi Gojek\n'
                '2. Tap ikon "QR" di halaman utama\n'
                '3. Scan QR Code pembayaran\n'
                '4. Masukkan nominal pembayaran\n'
                '5. Tap "Bayar" dan masukkan PIN\n'
                '6. Pembayaran berhasil',
          ),
        ];
      case 'DANA':
        return [
          const _HowToPay(
            title: 'Aplikasi DANA',
            steps:
                '1. Buka aplikasi DANA\n'
                '2. Pilih menu "Bayar"\n'
                '3. Pilih "Scan QR"\n'
                '4. Scan QR Code yang ditampilkan\n'
                '5. Masukkan jumlah pembayaran\n'
                '6. Konfirmasi dan masukkan PIN DANA\n'
                '7. Pembayaran berhasil',
          ),
          const _HowToPay(
            title: 'DANA via QRIS',
            steps:
                '1. Buka aplikasi DANA\n'
                '2. Tap ikon "QR" di halaman utama\n'
                '3. Scan QR Code pembayaran\n'
                '4. Masukkan nominal pembayaran\n'
                '5. Tap "Bayar" dan masukkan PIN\n'
                '6. Pembayaran berhasil',
          ),
        ];
      default:
        return [
          const _HowToPay(
            title: 'ATM / Mobile Banking',
            steps: 'Silakan lakukan pembayaran melalui ATM atau Mobile Banking ke nomor Virtual Account yang tertera di atas.',
          ),
        ];
    }
  }

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

                        // Minimal jeda 1.5 detik agar loading terlihat
                        await Future.delayed(const Duration(milliseconds: 1500));

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
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Selesaikan dalam ${_formatTime(_remainingSeconds)}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          'ORDER ID\n${booking.bookingCode}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
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
                    ..._paymentInstructions(booking.paymentMethod),
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
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    const ClipboardData(text: '8092 2796 3501'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nomor Virtual Account berhasil disalin'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
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

class _HowToPay extends StatefulWidget {
  final String title;
  final String steps;

  const _HowToPay({
    required this.title,
    this.steps = '',
  });

  @override
  State<_HowToPay> createState() => _HowToPayState();
}

class _HowToPayState extends State<_HowToPay> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && widget.steps.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.steps,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textDisabled,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}