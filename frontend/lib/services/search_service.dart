import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/hotel_model.dart';
import '../models/search_filter_model.dart';

class SearchService {
  static Future<List<HotelModel>> searchHotels(SearchFilterModel filter) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/hotel/search').replace(
      queryParameters: filter.toQueryParameters(),
    );

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari hotel');
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map && decoded.containsKey('data')
        ? decoded['data']
        : decoded;

    if (data is! List) {
      throw Exception('Format hasil pencarian tidak valid');
    }

    return data
        .where((item) => item is Map)
        .map((item) => HotelModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}