import 'hotel_model.dart';

class BookingModel {
  final HotelModel hotel;
  final RoomModel room;

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

  // Total & jumlah malam dari server (0 berarti tidak tersedia / pakai hitungan lokal).
  int totalHargaServer;
  int nightsServer;

  BookingModel({
    required this.hotel,
    required this.room,
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
    this.totalHargaServer = 0,
    this.nightsServer = 0,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Struktur dari backend: detail_booking -> kamar -> hotel
    Map<String, dynamic> roomJson = {};
    Map<String, dynamic> hotelJson = {};
    int nightsServer = 0;

    // Relasi dari Laravel di-serialize sebagai snake_case (detail_booking),
    // tapi tetap dukung camelCase sebagai cadangan.
    final detailList = json['detail_booking'] ?? json['detailBooking'];

    if (json['room'] != null && json['hotel'] != null) {
      roomJson = Map<String, dynamic>.from(json['room']);
      hotelJson = Map<String, dynamic>.from(json['hotel']);
    } else if (detailList is List && detailList.isNotEmpty) {
      final first = Map<String, dynamic>.from(detailList.first ?? {});
      nightsServer = HotelModel.parseInt(first['jumlah_malam']);
      if (first['kamar'] is Map) {
        roomJson = Map<String, dynamic>.from(first['kamar']);
        if (roomJson['hotel'] is Map) {
          hotelJson = Map<String, dynamic>.from(roomJson['hotel']);
        }
      }
    } else if (json['data'] is Map) {
      // sometimes wrapper
      return BookingModel.fromJson(Map<String, dynamic>.from(json['data']));
    }

    final idBooking = json['id_booking'];

    return BookingModel(
      hotel: HotelModel.fromJson(hotelJson),
      room: RoomModel.fromJson(roomJson),
      checkInDate: json['check_in'] == null ? null : DateTime.tryParse(json['check_in'].toString()),
      checkOutDate: json['check_out'] == null ? null : DateTime.tryParse(json['check_out'].toString()),
      guestName: (json['guest_name'] ?? json['guest'] ?? '').toString(),
      specialRequest: (json['special_request'] ?? json['specialRequest'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      paymentMethod: (json['payment_method'] ?? json['paymentMethod'] ?? '').toString(),
      bookingCode: idBooking != null
          ? 'BA-$idBooking'
          : (json['booking_code'] ?? json['bookingCode'] ?? '').toString(),
      itineraryId: (json['itinerary_id'] ?? json['itineraryId'] ?? idBooking ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      breakfast: (json['breakfast'] == 1 || json['breakfast'] == true),
      laundry: (json['laundry'] == 1 || json['laundry'] == true),
      airportPickup: (json['airport_pickup'] == 1 || json['airport_pickup'] == true),
      totalHargaServer: HotelModel.parseInt(json['total_harga']),
      nightsServer: nightsServer,
    );
  }

  int get nights {
    if (checkInDate == null || checkOutDate == null) {
      return 0;
    }

    return checkOutDate!.difference(checkInDate!).inDays;
  }

  // Jumlah malam: pakai data server bila ada, jika tidak hitung dari tanggal.
  int get displayNights => nightsServer > 0 ? nightsServer : nights;

  // Total bayar: pakai total_harga dari server bila ada (yang benar-benar
  // tersimpan), jika tidak hitung lokal dari kamar + pajak + add-on.
  int get displayTotal => totalHargaServer > 0 ? totalHargaServer : totalPayment;

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