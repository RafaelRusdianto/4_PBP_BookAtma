// For Android emulator, use

// class ApiConfig {
//   static const String baseUrl = 'http://10.0.2.2:8000/api';
// }

// For Web, use
// class ApiConfig {
//   static const String baseUrl = 'http://127.0.0.1:8000/api';
// }

class ApiConfig {
  // Untuk emulator Android ketika Laravel jalan dengan php artisan serve.
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api';

  // Untuk HP asli. Ganti IP sesuai IPv4 laptop kamu.
  static const String phoneBaseUrl = 'http://192.168.100.59:8000/api';

  // Untuk nanti kalau backend Laravel sudah di-hosting.
  static const String hostedBaseUrl = 'https://domain-kamu.com/api';

  // Data aplikasi diambil dari API Laravel, bukan dummy.
  static const bool useDummyData = false;

  // Nanti kalau sudah connect Laravel, ganti ke emulatorBaseUrl / phoneBaseUrl / hostedBaseUrl.
  static const String baseUrl = emulatorBaseUrl;
}
