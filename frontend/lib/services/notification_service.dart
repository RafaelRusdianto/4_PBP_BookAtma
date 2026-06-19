import '../core/format_helper.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';
import 'booking_service.dart';

class NotificationService {
  // Bangun daftar notifikasi dari pesanan aktif user.
  // - "Pemesanan berhasil" untuk setiap booking aktif.
  // - "Reminder check-in" hanya jika hari ini = H-1 sebelum check-in.
  static Future<List<NotificationModel>> getNotifications() async {
    final bookings = await BookingService.getActiveBookings();

    // Urutkan booking dari yang terbaru (id_booking terbesar) ke terlama,
    // sehingga notifikasi paling baru berada paling atas.
    final sortedBookings = [...bookings]
      ..sort((a, b) => _bookingId(b).compareTo(_bookingId(a)));

    final List<NotificationModel> notifications = [];

    for (final booking in sortedBookings) {
      // Reminder ditaruh lebih dulu (kejadian paling baru: H-1 hari ini).
      if (_isOneDayBeforeCheckIn(booking.checkInDate)) {
        notifications.add(
          NotificationModel(
            type: NotificationType.checkInReminder,
            title: 'Pengingat Check-in',
            message:
                'Besok (${FormatHelper.fullDate(booking.checkInDate)}) jadwal check-in kamu di ${booking.hotel.name}. Jangan lupa siapkan dokumenmu!',
            bookingCode: booking.bookingCode,
            date: booking.checkInDate,
          ),
        );
      }

      // Notifikasi pemesanan berhasil.
      notifications.add(
        NotificationModel(
          type: NotificationType.bookingSuccess,
          title: 'Pemesanan Berhasil',
          message:
              'Pesananmu di ${booking.hotel.name} berhasil dibuat. Selamat menikmati perjalananmu!',
          bookingCode: booking.bookingCode,
          date: booking.checkInDate,
        ),
      );
    }

    return notifications;
  }

  // Ambil id_booking numerik dari kode booking untuk pengurutan.
  static int _bookingId(BookingModel booking) =>
      int.tryParse(booking.bookingCode) ?? 0;

  // Jumlah notifikasi untuk badge di tombol lonceng.
  static Future<int> getUnreadCount() async {
    try {
      final notifications = await getNotifications();
      return notifications.length;
    } catch (_) {
      return 0;
    }
  }

  // True jika selisih hari antara hari ini dan tanggal check-in tepat 1 hari.
  static bool _isOneDayBeforeCheckIn(DateTime? checkIn) {
    if (checkIn == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInDay = DateTime(checkIn.year, checkIn.month, checkIn.day);

    return checkInDay.difference(today).inDays == 1;
  }
}
