import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class AuthService {
  Future<bool> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),

      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);

      return true;
    }

    return false;
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
}
