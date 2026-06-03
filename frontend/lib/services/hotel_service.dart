import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/hotel_model.dart';

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

    return Future.wait(selectedHotels.map(_fetchDetailOrFallback));
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

    return baseHotel == null ? detail : _mergeHotel(baseHotel, detail);
  }

  static Future<HotelModel> _fetchDetailOrFallback(HotelModel hotel) async {
    if (hotel.idHotel <= 0) return hotel;

    try {
      return await fetchHotelDetail(hotel.idHotel, baseHotel: hotel);
    } catch (_) {
      return hotel;
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
