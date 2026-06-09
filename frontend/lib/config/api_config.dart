import 'package:flutter/foundation.dart';

class ApiConfig {
  // Untuk emulator Android ketika Laravel jalan dengan php artisan serve.
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Untuk web, desktop, dan iOS simulator.
  // static const String localBaseUrl = 'http://127.0.0.1:8000/api';

  // Untuk HP asli. Ganti IP sesuai IPv4 laptop kamu.
  static const String baseUrl = 'http://192.168.100.59:8000/api';

  // Untuk nanti kalau backend Laravel sudah di-hosting.
  // static const String hostedBaseUrl = 'https://domain-kamu.com/api';
}
