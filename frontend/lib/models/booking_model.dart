import 'hotel_model.dart';

class BookingModel {
  final HotelModel hotel;
  final RoomModel room;
  final int? idBooking;
  final int? idPembayaran;
  final int? backendTotalPayment;

  DateTime? checkInDate;
  DateTime? checkOutDate;

  String guestName;
  String specialRequest;
  String note;
  String paymentMethod;
  String bookingCode;
  String itineraryId;
  String status;

  bool breakfast;
  bool laundry;
  bool airportPickup;

  BookingModel({
    required this.hotel,
    required this.room,
    this.idBooking,
    this.idPembayaran,
    this.backendTotalPayment,
    this.checkInDate,
    this.checkOutDate,
    this.guestName = 'Budi Santoso',
    this.specialRequest = '',
    this.note = '',
    this.paymentMethod = '',
    this.bookingCode = 'BA-9822104',
    this.itineraryId = '1092837465',
    this.status = 'Menunggu Pembayaran',
    this.breakfast = false,
    this.laundry = false,
    this.airportPickup = false,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is Map) {
      return BookingModel.fromJson(Map<String, dynamic>.from(json['data']));
    }

    // Backend may provide nested structure: detailBooking -> kamar -> hotel
    Map<String, dynamic> roomJson = {};
    Map<String, dynamic> hotelJson = {};
    Map<String, dynamic> paymentJson = {};
    final detailBookings = json['detailBooking'] ?? json['detail_booking'];

    if (json['room'] != null && json['hotel'] != null) {
      roomJson = Map<String, dynamic>.from(json['room']);
      hotelJson = Map<String, dynamic>.from(json['hotel']);
    } else if (detailBookings is List && detailBookings.isNotEmpty) {
      final first = Map<String, dynamic>.from(detailBookings.first ?? {});
      if (first['kamar'] is Map) {
        roomJson = Map<String, dynamic>.from(first['kamar']);
        if (roomJson['hotel'] is Map) {
          hotelJson = Map<String, dynamic>.from(roomJson['hotel']);
        }
      }
    }

    if (json['pembayaran'] is Map) {
      paymentJson = Map<String, dynamic>.from(json['pembayaran']);
    }

    return BookingModel(
      hotel: HotelModel.fromJson(hotelJson),
      room: RoomModel.fromJson(roomJson),
      idBooking: _toInt(json['id_booking']),
      idPembayaran: _toInt(paymentJson['id_pembayaran']),
      backendTotalPayment: _toInt(json['total_harga']),
      checkInDate: json['check_in'] == null ? null : DateTime.tryParse(json['check_in'].toString()),
      checkOutDate: json['check_out'] == null ? null : DateTime.tryParse(json['check_out'].toString()),
      guestName: (json['guest_name'] ?? json['guest'] ?? '').toString(),
      specialRequest: (json['special_request'] ?? json['specialRequest'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      paymentMethod: (json['payment_method'] ??
              json['paymentMethod'] ??
              paymentJson['metode_pembayaran'] ??
              '')
          .toString(),
      bookingCode: (json['booking_code'] ?? json['bookingCode'] ?? json['id_booking'] ?? '').toString(),
      itineraryId: (json['itinerary_id'] ?? json['itineraryId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      breakfast: (json['breakfast'] == 1 || json['breakfast'] == true),
      laundry: (json['laundry'] == 1 || json['laundry'] == true),
      airportPickup: (json['airport_pickup'] == 1 || json['airport_pickup'] == true),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    final text = value.toString().trim();
    final direct = num.tryParse(text);

    if (direct != null) return direct.toInt();

    final normalized = text
        .replaceAll(RegExp(r'[^0-9,.]'), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final localized = num.tryParse(normalized);

    if (localized != null) return localized.toInt();

    return null;
  }

  int get nights {
    if (checkInDate == null || checkOutDate == null) {
      return 0;
    }

    return checkOutDate!.difference(checkInDate!).inDays;
  }

  int get roomTotal {
    int totalNight = nights == 0 ? 1 : nights;
    return room.price * totalNight;
  }

  int get tax {
    return 269500;
  }

  int get addOnTotal {
    int total = 0;

    if (breakfast) {
      total += 150000;
    }

    if (laundry) {
      total += 50000;
    }

    if (airportPickup) {
      total += 250000;
    }

    return total;
  }

  int get totalPayment {
    if (backendTotalPayment != null && backendTotalPayment! > 0) {
      return backendTotalPayment!;
    }

    return roomTotal + tax + addOnTotal;
  }

  List<String> get selectedAddOns {
    List<String> data = [];

    if (breakfast) {
      data.add('Sarapan untuk 2 orang');
    }

    if (laundry) {
      data.add('Laundry Service');
    }

    if (airportPickup) {
      data.add('Antar Jemput Bandara');
    }

    return data;
  }
}
