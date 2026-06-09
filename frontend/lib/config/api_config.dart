import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }

    // Untuk iOS simulator, desktop, dan build native lain di mesin yang sama.
    return 'http://127.0.0.1:8000/api';
  }

  // Jika kamu menggunakan perangkat nyata, ganti baseUrl di atas dengan IP PC:
  // static const String deviceBaseUrl = 'http://192.168.1.145:8000/api';
}
