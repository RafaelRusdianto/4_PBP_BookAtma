enum NotificationType {
  bookingSuccess,
  checkInReminder,
}

class NotificationModel {
  final NotificationType type;
  final String title;
  final String message;
  final String bookingCode;

  // Tanggal acuan notifikasi (mis. tanggal check-in untuk reminder).
  final DateTime? date;

  NotificationModel({
    required this.type,
    required this.title,
    required this.message,
    this.bookingCode = '',
    this.date,
  });
}
