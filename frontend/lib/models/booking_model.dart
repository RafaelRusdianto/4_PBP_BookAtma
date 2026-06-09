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
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Backend may provide nested structure: detailBooking -> kamar -> hotel
    Map<String, dynamic> roomJson = {};
    Map<String, dynamic> hotelJson = {};

    if (json['room'] != null && json['hotel'] != null) {
      roomJson = Map<String, dynamic>.from(json['room']);
      hotelJson = Map<String, dynamic>.from(json['hotel']);
    } else if (json['detailBooking'] is List && (json['detailBooking'] as List).isNotEmpty) {
      final first = Map<String, dynamic>.from((json['detailBooking'] as List).first ?? {});
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

    return BookingModel(
      hotel: HotelModel.fromJson(hotelJson),
      room: RoomModel.fromJson(roomJson),
      checkInDate: json['check_in'] == null ? null : DateTime.tryParse(json['check_in'].toString()),
      checkOutDate: json['check_out'] == null ? null : DateTime.tryParse(json['check_out'].toString()),
      guestName: (json['guest_name'] ?? json['guest'] ?? '').toString(),
      specialRequest: (json['special_request'] ?? json['specialRequest'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      paymentMethod: (json['payment_method'] ?? json['paymentMethod'] ?? '').toString(),
      bookingCode: (json['booking_code'] ?? json['bookingCode'] ?? '').toString(),
      itineraryId: (json['itinerary_id'] ?? json['itineraryId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      breakfast: (json['breakfast'] == 1 || json['breakfast'] == true),
      laundry: (json['laundry'] == 1 || json['laundry'] == true),
      airportPickup: (json['airport_pickup'] == 1 || json['airport_pickup'] == true),
    );
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