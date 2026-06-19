class ApiConfig {
  // Untuk emulator Android ketika Laravel jalan dengan php artisan serve.
  // static const String aseUrl = 'http://10.0.2.2:8000/api';

  // Untuk web, desktop, dan iOS simulator.
  // static const String localBaseUrl = 'http://127.0.0.1:8000/api';

  // Untuk HP asli. Ganti IP sesuai IPv4 laptop kamu.

  static const String baseUrl = 'http://172.20.10.2:8000/api';

  // Untuk nanti kalau backend Laravel sudah di-hosting.
  // static const String hostedBaseUrl = 'https://domain-kamu.com/api';

  // Google OAuth Web Client ID (dari Google Cloud Console).
  // ID ini harus cocok dengan GOOGLE_CLIENT_ID di .env backend.
  static const String googleServerClientId =
      '611870269039-688jq7lamk42ucsq3524sfcc7nsoj0tg.apps.googleusercontent.com';

  // Supabase Storage public URL untuk foto hotel & kamar.
  // Path dari DB (hotels/... atau rooms/...) langsung dipakai setelah URL ini.
  static const String supabaseStorageUrl =
      'https://rfzyatyhbdsfykdhprwy.supabase.co/storage/v1/object/public';
}
