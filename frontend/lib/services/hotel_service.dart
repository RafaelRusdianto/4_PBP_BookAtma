import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/hotel_model.dart';
import 'review_service.dart';

class HotelService {
  Future<List<HotelModel>> getHotels({int? limit}) {
    return fetchHotels(limit: limit);
  }

  Future<HotelModel> getHotelDetail(int idHotel, {HotelModel? baseHotel}) {
    return fetchHotelDetail(idHotel, baseHotel: baseHotel);
  }

  Future<List<HotelModel>> getRecommendedHotels({int limit = 5}) {
    return fetchHotels(limit: limit);
  }

  static Future<List<HotelModel>> fetchHotels({int? limit}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/hotel'),
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data hotel');
    }

    final data = _extractData(response.body);

    if (data is! List) {
      throw Exception('Format data hotel tidak valid');
    }

    final hotels = data
        .where((item) => item is Map)
        .map((item) => HotelModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    hotels.sort((a, b) => b.rating.compareTo(a.rating));

    final selectedHotels = limit == null ? hotels : hotels.take(limit).toList();

    // _fetchDetailOrFallback sudah menerapkan rating dari review asli.
    final enriched = await Future.wait(selectedHotels.map(_fetchDetailOrFallback));

    // Urutkan ulang berdasarkan rating asli dari review.
    enriched.sort((a, b) => b.rating.compareTo(a.rating));

    return enriched;
  }

  // Hitung avg_rating dari rata-rata rating review hotel yang sesungguhnya.
  static Future<HotelModel> _applyReviewRating(HotelModel hotel) async {
    if (hotel.idHotel <= 0) return hotel;

    try {
      final reviews = await ReviewService.getReviewsByHotel(hotel.idHotel);

      // Hanya hitung review yang punya rating valid (> 0).
      final ratings =
          reviews.map((r) => r.rating).where((rating) => rating > 0).toList();

      if (ratings.isEmpty) return hotel;

      final average =
          ratings.reduce((a, b) => a + b) / ratings.length;

      return hotel.copyWith(avgRating: average);
    } catch (_) {
      // Bila gagal memuat review, pakai rating bawaan dari backend.
      return hotel;
    }
  }

  static Future<HotelModel> fetchHotelDetail(
    int idHotel, {
    HotelModel? baseHotel,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/hotel/$idHotel'),
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail hotel');
    }

    final data = _extractData(response.body);

    if (data is! Map) {
      throw Exception('Format detail hotel tidak valid');
    }

    final detail = HotelModel.fromJson(Map<String, dynamic>.from(data));

    final merged = baseHotel == null ? detail : _mergeHotel(baseHotel, detail);

    return _applyReviewRating(merged);
  }

  static Future<HotelModel> _fetchDetailOrFallback(HotelModel hotel) async {
    if (hotel.idHotel <= 0) return hotel;

    try {
      // fetchHotelDetail sudah menerapkan rating dari review.
      return await fetchHotelDetail(hotel.idHotel, baseHotel: hotel);
    } catch (_) {
      // Detail gagal dimuat, tetap pakai rating review jika tersedia.
      return _applyReviewRating(hotel);
    }
  }

  static HotelModel _mergeHotel(HotelModel baseHotel, HotelModel detailHotel) {
    final imageUrls = detailHotel.imageUrls.isNotEmpty
        ? detailHotel.imageUrls
        : baseHotel.imageUrls;

    final rooms = detailHotel.rooms.isNotEmpty
        ? detailHotel.rooms
            .map((room) {
              if (room.imageUrl.isNotEmpty || imageUrls.isEmpty) return room;

              return room.copyWith(imageUrl: imageUrls.first);
            })
            .toList()
        : baseHotel.rooms;

    return detailHotel.copyWith(
      imageUrls: imageUrls,
      rooms: rooms,
      facilities: detailHotel.facilities.isNotEmpty
          ? detailHotel.facilities
          : baseHotel.facilities,
      hargaMulai: detailHotel.hargaMulai ?? baseHotel.hargaMulai,
    );
  }

  static dynamic _extractData(String responseBody) {
    final decoded = jsonDecode(responseBody);

    if (decoded is Map && decoded.containsKey('data')) {
      return decoded['data'];
    }

    return decoded;
  }
}
