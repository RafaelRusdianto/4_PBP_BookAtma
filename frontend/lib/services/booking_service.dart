import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/booking_model.dart';
import '../models/hotel_model.dart';
import '../config/api_config.dart';

class BookingService {
  static BookingModel? currentBooking;

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
    // keep previous behavior for local flows
    await Future.delayed(const Duration(seconds: 1));

    if (currentBooking == null) {
      return false;
    }

    currentBooking!.status = 'Booking Berhasil';
    return true;
  }

  // --- Networked API methods ---
  static Future<List<BookingModel>> getActiveBookings() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/active');
    final res = await http.get(uri);

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
    final res = await http.get(uri);

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
    final res = await http.get(uri);

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