import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/hotel_model.dart';

class HotelService {
  Future<List<HotelModel>> getHotels() async {
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

    return data
        .where((item) => item is Map)
        .map((item) => HotelModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<HotelModel> getHotelDetail(int idHotel) async {
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

    return HotelModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<List<HotelModel>> getRecommendedHotels({int limit = 5}) async {
    if (limit <= 0) return [];

    final hotels = await getHotels();

    hotels.sort((a, b) => b.avgRating.compareTo(a.avgRating));

    final selectedHotels = hotels.take(limit).toList();

    return Future.wait(selectedHotels.map(_loadDetailOrFallback));
  }

  Future<HotelModel> _loadDetailOrFallback(HotelModel hotel) async {
    if (hotel.idHotel <= 0) return hotel;

    try {
      final detail = await getHotelDetail(hotel.idHotel);

      return detail.copyWith(
        imageUrl: detail.imageUrl ?? hotel.imageUrl,
        hargaMulai: detail.hargaMulai ?? hotel.hargaMulai,
        kapasitas: detail.kapasitas ?? hotel.kapasitas,
      );
    } catch (_) {
      return hotel;
    }
  }

  dynamic _extractData(String responseBody) {
    final decoded = jsonDecode(responseBody);

    if (decoded is Map && decoded.containsKey('data')) {
      return decoded['data'];
    }

    return decoded;
  }
}
