import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),

        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = _decodeObject(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];

        if (token is! String || token.isEmpty) {
          return {
            'success': false,
            'message': 'Token login tidak ditemukan di response server',
          };
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
        };
      }

      return {
        'success': false,
        'message': _errorMessage(data, fallback: 'Email atau password salah'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa backend dan URL API. (${e.toString()})',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
    required String noHp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),

        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'no_hp': noHp,
        }),
      );

      final data = jsonDecode(response.body);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      } else {
        String errorMessage = 'Register gagal';

        if (data['message'] != null) {
          errorMessage = data['message'];
        }

        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;

          errorMessage = errors.values.first[0];
        }

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/logout'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    await prefs.remove('token');
  }

  Map<String, dynamic> _decodeObject(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return {};
    }

    return {};
  }

  String _errorMessage(
    Map<String, dynamic> data, {
    required String fallback,
  }) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;

    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }

      return firstError.toString();
    }

    return fallback;
  }
}
