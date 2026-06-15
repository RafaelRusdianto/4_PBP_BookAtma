import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';
import '../models/hotel_model.dart';
import '../config/api_config.dart';

class BookingService {
  static BookingModel? currentBooking;

  // Header dengan token Sanctum untuk endpoint yang butuh autentikasi.
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static void startBooking({
    required HotelModel hotel,
    required RoomModel room,
  }) {
    currentBooking = BookingModel(
      hotel: hotel,
      room: room,
    );
  }

  static void setDates({
    required DateTime checkIn,
    required DateTime checkOut,
  }) {
    currentBooking?.checkInDate = checkIn;
    currentBooking?.checkOutDate = checkOut;
  }

  static void setAddOns({
    required bool breakfast,
    required bool laundry,
    required bool airportPickup,
    required String specialRequest,
    required String note,
  }) {
    currentBooking?.breakfast = breakfast;
    currentBooking?.laundry = laundry;
    currentBooking?.airportPickup = airportPickup;
    currentBooking?.specialRequest = specialRequest;
    currentBooking?.note = note;
  }

  static void setPaymentMethod(String method) {
    currentBooking?.paymentMethod = method;
  }

  static Future<Map<String, dynamic>> submitBooking() async {
    final booking = currentBooking;
    if (booking == null) {
      return {'success': false, 'message': 'Data booking tidak ditemukan'};
    }

    // Tanggal wajib ada untuk disimpan ke backend.
    final checkIn = booking.checkInDate;
    final checkOut = booking.checkOutDate;
    if (checkIn == null || checkOut == null) {
      return {'success': false, 'message': 'Tanggal check-in/check-out belum dipilih'};
    }

    if (booking.room.idRoom == 0) {
      return {'success': false, 'message': 'Kamar tidak valid (id_kamar kosong)'};
    }

    try {
      // 1. Kirim booking ke backend (sekarang pakai auth token, id_user dari server)
      final uri = Uri.parse('${ApiConfig.baseUrl}/booking');
      final res = await http.post(
        uri,
        headers: {
          ...await _authHeaders(),
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_kamar': booking.room.idRoom,
          'check_in': _formatDate(checkIn),
          'check_out': _formatDate(checkOut),
          'total_harga': booking.totalPayment,
          'harga_per_malam': booking.room.price,
          'breakfast': booking.breakfast,
          'laundry': booking.laundry,
          'airport_pickup': booking.airportPickup,
          'special_request': booking.specialRequest,
          'note': booking.note,
          'payment_method': booking.paymentMethod,
        }),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        final body = json.decode(res.body);
        final msg = body['message'] ?? 'Gagal menyimpan booking: ${res.statusCode}';
        return {'success': false, 'message': msg};
      }

      final responseData = json.decode(res.body);
      booking.status = 'Booking Berhasil';

      // Update booking code dari server
      final serverData = responseData['data'];
      if (serverData is Map) {
        final idBooking = serverData['id_booking'];
        if (idBooking != null) {
          booking.bookingCode = 'BA-$idBooking';
          booking.itineraryId = idBooking.toString();
        }
      }

      return {
        'success': true,
        'message': 'Booking berhasil disimpan',
        'data': responseData,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  // --- Networked API methods ---
  static Future<List<BookingModel>> getActiveBookings() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/active');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat pesanan aktif: ${res.statusCode} - ${res.body}');
    }

    final body = json.decode(res.body);
    List items = [];

    if (body is Map && body['data'] is List) {
      items = body['data'];
    } else if (body is List) {
      items = body;
    }

    return items.map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<List<BookingModel>> getHistoryBookings() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/history');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat riwayat pesanan: ${res.statusCode} - ${res.body}');
    }

    final body = json.decode(res.body);
    List items = [];

    if (body is Map && body['data'] is List) {
      items = body['data'];
    } else if (body is List) {
      items = body;
    }

    return items.map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<BookingModel> getBookingDetail(String bookingId) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail pesanan: ${res.statusCode} - ${res.body}');
    }

    final body = json.decode(res.body);
    return BookingModel.fromJson(Map<String, dynamic>.from(body));
  }

  static Future<bool> submitReview(String bookingId, int rating, String review) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/$bookingId/review');
    final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rating': rating, 'review': review}));

    return res.statusCode == 200 || res.statusCode == 201;
  }
}