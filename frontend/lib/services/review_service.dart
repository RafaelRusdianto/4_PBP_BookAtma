import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/review_model.dart';

class ReviewService {
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, String>> _authHeadersMultipart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Simpan rating saja (create atau update jika sudah ada)
  static Future<Map<String, dynamic>> saveRating({
    required int idPembayaran,
    required int idHotel,
    required int rating,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/review/rating');
      final res = await http.post(
        uri,
        headers: await _authHeaders(),
        body: json.encode({
          'id_pembayaran': idPembayaran,
          'id_hotel': idHotel,
          'rating': rating,
        }),
      );

      final body = json.decode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Rating berhasil disimpan',
          'data': body['data'],
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal menyimpan rating',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  /// Update keterangan/ulasan
  static Future<Map<String, dynamic>> updateKeterangan({
    required int idReview,
    required String keterangan,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/review/$idReview/keterangan');
      final res = await http.put(
        uri,
        headers: await _authHeaders(),
        body: json.encode({
          'keterangan': keterangan,
        }),
      );

      final body = json.decode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Ulasan berhasil diperbarui',
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal memperbarui ulasan',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  /// Upload foto untuk review tertentu
  static Future<Map<String, dynamic>> uploadFoto({
    required int idReview,
    required List<File> files,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/review/$idReview/upload-foto');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await _authHeadersMultipart());

      for (final file in files) {
        request.files.add(
          await http.MultipartFile.fromPath('foto[]', file.path),
        );
      }

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      final body = json.decode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Foto berhasil diupload',
          'data': body['data'],
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal upload foto',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  /// Ambil semua review untuk hotel tertentu
  static Future<List<ReviewModel>> getReviewsByHotel(int idHotel) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/review/hotel/$idHotel');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat review: ${res.statusCode}');
    }

    final body = json.decode(res.body);
    List items = [];

    if (body is Map && body['data'] is List) {
      items = body['data'];
    }

    return items
        .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Cari review berdasarkan id_pembayaran
  static Future<ReviewModel?> getReviewByPembayaran(int idPembayaran) async {
    try {
      final uri =
          Uri.parse('${ApiConfig.baseUrl}/review/pembayaran/$idPembayaran');
      final res = await http.get(uri, headers: await _authHeaders());

      if (res.statusCode != 200) return null;

      final body = json.decode(res.body);
      final data = body['data'];

      if (data == null) return null;

      return ReviewModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }
}
