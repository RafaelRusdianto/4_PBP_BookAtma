import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../services/booking_service.dart';
import '../../services/pdf_service.dart';

class VoucherPdfPreviewPage extends StatelessWidget {
  const VoucherPdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = BookingService.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Preview PDF'),
        ),
        body: const Center(
          child: Text('Data booking belum tersedia'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Voucher PDF'),
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        build: (format) {
          return PdfService.createVoucherPdf(booking);
        },
      ),
    );
  }
}