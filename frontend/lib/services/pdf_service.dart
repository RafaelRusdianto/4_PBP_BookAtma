import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/format_helper.dart';
import '../models/booking_model.dart';

class PdfService {
  static Future<Uint8List> createVoucherPdf(BookingModel booking) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _header(),
              _bookingInfo(booking),
              pw.Padding(
                padding: const pw.EdgeInsets.all(24),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Hotel Information'),
                    pw.SizedBox(height: 12),
                    _hotelInfo(booking),
                    pw.SizedBox(height: 24),
                    _sectionTitle('Room & Guest Details'),
                    pw.SizedBox(height: 12),
                    _roomTable(booking),
                    pw.SizedBox(height: 24),
                    _policySection(),
                    pw.SizedBox(height: 30),
                    _footer(booking),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Container(
                height: 8,
                color: PdfColor.fromHex('#0064D2'),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _header() {
    return pw.Container(
      color: PdfColor.fromHex('#0064D2'),
      padding: const pw.EdgeInsets.all(24),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Hotel Voucher',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Please present this voucher upon check-in',
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'BookAtma',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Travel with Confidence',
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _bookingInfo(BookingModel booking) {
    return pw.Container(
      color: PdfColor.fromHex('#FFF9DB'),
      padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _topInfo('BOOKING ID', booking.bookingCode),
          _topInfo('ITINERARY ID', booking.itineraryId),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'STATUS',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 9,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#D9FBE6'),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  'Confirmed',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#16A34A'),
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _topInfo(String title, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            color: PdfColors.grey,
            fontSize: 9,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: PdfColor.fromHex('#0064D2'),
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 15,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  static pw.Widget _hotelInfo(BookingModel booking) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                booking.hotel.name,
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                booking.hotel.location,
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 11,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Guest: ${booking.guestName}',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Payment: ${booking.paymentMethod}',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Container(
          width: 210,
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#F4F7FB'),
            borderRadius: pw.BorderRadius.circular(10),
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _dateColumn(
                      'CHECK-IN',
                      FormatHelper.fullDate(booking.checkInDate),
                      'From 14:00',
                    ),
                  ),
                  pw.Expanded(
                    child: _dateColumn(
                      'CHECK-OUT',
                      FormatHelper.fullDate(booking.checkOutDate),
                      'Before 12:00',
                    ),
                  ),
                ],
              ),
              pw.Divider(height: 22),
              pw.Text(
                'DURATION',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 9,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${booking.nights} Nights, 1 Room',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _dateColumn(String title, String value, String desc) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            color: PdfColors.grey,
            fontSize: 8,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          desc,
          style: const pw.TextStyle(
            color: PdfColors.grey,
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  static pw.Widget _roomTable(BookingModel booking) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#F4F7FB'),
          ),
          children: [
            _tableCell('ROOM TYPE', true),
            _tableCell('LEAD GUEST', true),
            _tableCell('CAPACITY', true),
            _tableCell('BENEFITS', true),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell(booking.room.name, false),
            _tableCell(booking.guestName, false),
            _tableCell('${booking.room.capacity} Adults', false),
            _tableCell(
              booking.selectedAddOns.isEmpty
                  ? 'Room Only'
                  : booking.selectedAddOns.join(', '),
              false,
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _tableCell(String text, bool header) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: header ? 9 : 10,
          color: header ? PdfColors.grey700 : PdfColors.black,
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _policySection() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Cancellation Policy',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FFEDED'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'NON-REFUNDABLE\nThis booking is non-refundable. Any cancellation or no-show will be charged in full.',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#D32F2F'),
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 18),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Important Information',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Valid government-issued ID is required upon check-in.\n\nA security deposit may be required by the hotel at check-in.\n\nSpecial requests are subject to availability.',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _footer(BookingModel booking) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      color: PdfColor.fromHex('#F4F7FB'),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PAYMENT TOTAL',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  FormatHelper.rupiah(booking.totalPayment),
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#0064D2'),
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'NEED HELP?',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Contact our 24/7 Customer Service\n0804-1-500-303 | cs@bookatma.com',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          pw.Container(
            width: 95,
            height: 95,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: booking.bookingCode,
            ),
          ),
        ],
      ),
    );
  }
}