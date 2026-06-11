import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';
import '../models/hotel_model.dart';
import '../config/api_config.dart';

class BookingService {
  static BookingModel? currentBooking;
  static String? lastError;

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

  static Future<bool> submitBooking() async {
    lastError = null;

    if (currentBooking == null) {
      lastError = 'Data booking belum tersedia';
      return false;
    }

    final booking = currentBooking!;
    if (booking.checkInDate == null || booking.checkOutDate == null) {
      lastError = 'Tanggal check-in dan check-out belum dipilih';
      return false;
    }

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/bookings');
      final headers = await _authHeaders();
      final res = await http.post(
        uri,
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_kamar': booking.room.idRoom,
          'check_in': _dateOnly(booking.checkInDate!),
          'check_out': _dateOnly(booking.checkOutDate!),
          'harga_per_malam': booking.room.price,
          'jumlah_malam': booking.nights == 0 ? 1 : booking.nights,
          'total_harga': booking.totalPayment,
          'metode_pembayaran': booking.paymentMethod,
          'breakfast': booking.breakfast,
          'laundry': booking.laundry,
          'airport_pickup': booking.airportPickup,
        }),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        lastError = _responseMessage(res.body) ?? 'Booking gagal diproses';
        return false;
      }

      final body = json.decode(res.body);
      final savedBooking = BookingModel.fromJson(Map<String, dynamic>.from(body));
      savedBooking.breakfast = booking.breakfast;
      savedBooking.laundry = booking.laundry;
      savedBooking.airportPickup = booking.airportPickup;
      savedBooking.specialRequest = booking.specialRequest;
      savedBooking.note = booking.note;
      currentBooking = savedBooking;
      return true;
    } catch (_) {
      lastError = 'Tidak dapat terhubung ke server';
      return false;
    }
  }

  static String _dateOnly(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '${value.year}-$month-$day';
  }

  static String? _responseMessage(String responseBody) {
    try {
      final decoded = json.decode(responseBody);

      if (decoded is Map) {
        final message = decoded['message'];
        if (message != null) return message.toString();

        final errors = decoded['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }

          return firstError.toString();
        }
      }
    } catch (_) {}

    return null;
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
