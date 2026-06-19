class ApiConfig {
  // Untuk emulator Android ketika Laravel jalan dengan php artisan serve.
  // static const String aseUrl = 'http://10.0.2.2:8000/api';

  // Untuk web, desktop, dan iOS simulator.
  // static const String localBaseUrl = 'http://127.0.0.1:8000/api';

  // Untuk HP asli. Ganti IP sesuai IPv4 laptop kamu.
<<<<<<< Updated upstream
  static const String baseUrl = 'https://4pbpbookatma-production.up.railway.app/api';
=======

  // static const String baseUrl =
  //     'https://4pbpbookatma-production.up.railway.app/api';

  static const String baseUrl =
      'http://172.23.44.165:8000/api';
>>>>>>> Stashed changes

  // Untuk nanti kalau backend Laravel sudah di-hosting.
  // static const String hostedBaseUrl = 'https://domain-kamu.com/api';

  // Google OAuth Web Client ID (dari Google Cloud Console).
  // ID ini harus cocok dengan GOOGLE_CLIENT_ID di .env backend.
  static const String googleServerClientId =
      '611870269039-688jq7lamk42ucsq3524sfcc7nsoj0tg.apps.googleusercontent.com';
}
