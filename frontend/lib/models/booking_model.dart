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