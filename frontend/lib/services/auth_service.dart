import 'dart:convert';
import 'dart:io';

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

        final nama = data['user']?['nama'];
        if (nama is String && nama.isNotEmpty) {
          await prefs.setString('nama', nama);
        }

        final idUser = data['user']?['id_user'];
        if (idUser != null) {
          await prefs.setInt('id_user', int.tryParse(idUser.toString()) ?? 0);
        }

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
    await prefs.remove('nama');
    await prefs.remove('id_user');
  }

  // Nama user yang sedang login. Pakai cache dari login dulu, kalau kosong
  // ambil dari endpoint /profile memakai token.
  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString('nama');
    if (cached != null && cached.isNotEmpty) return cached;

    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return '';

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = _decodeObject(response.body);
        final nama = data['data']?['nama'];
        if (nama is String && nama.isNotEmpty) {
          await prefs.setString('nama', nama);
          return nama;
        }
      }
    } catch (_) {}

    return '';
  }

  // Ambil data user yang sedang login dari endpoint /profile (auth()->user()).
  // Mengembalikan map berisi nama, email, no_hp, dll. atau null bila gagal.
  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = _decodeObject(response.body);
        final user = data['data'];
        if (user is Map) {
          return Map<String, dynamic>.from(user);
        }
      }
    } catch (_) {}

    return null;
  }

  // Perbarui profil user yang sedang login (POST /profile, auth()->user()).
  // foto opsional; bila ada dikirim sebagai multipart 'foto_profil'.
  Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String email,
    required String noHp,
    File? foto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      return {
        'success': false,
        'message': 'Sesi tidak valid. Silakan login ulang.',
      };
    }

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/profile');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['nama'] = nama;
      request.fields['email'] = email;
      request.fields['no_hp'] = noHp;

      if (foto != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_profil', foto.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      final data = _decodeObject(response.body);

      if (response.statusCode == 200) {
        final user = data['data'];
        if (user is Map) {
          final newNama = user['nama'];
          if (newNama is String && newNama.isNotEmpty) {
            await prefs.setString('nama', newNama);
          }
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Profil berhasil diperbarui',
          'data': user,
        };
      }

      return {
        'success': false,
        'message': _errorMessage(data, fallback: 'Gagal memperbarui profil'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
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
