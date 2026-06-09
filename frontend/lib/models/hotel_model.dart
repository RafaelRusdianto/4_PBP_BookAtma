import '../config/api_config.dart';

class HotelModel {
  final int idHotel;
  final String nama;
  final String alamat;
  final double avgRating;
  final String deskripsi;
  final List<String> imageUrls;
  final List<RoomModel> rooms;
  final List<String> facilities;
  final String? hargaMulai;

  HotelModel({
    required this.idHotel,
    required this.nama,
    required this.alamat,
    required this.avgRating,
    required this.deskripsi,
    this.imageUrls = const [],
    this.rooms = const [],
    this.facilities = const [],
    this.hargaMulai,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final imageUrls = _photoUrls(json['foto']);
    final rooms = _roomList(json['kamar'], _firstOrNull(imageUrls));

    return HotelModel(
      idHotel: _toInt(json['id_hotel']) ?? 0,
      nama: (json['nama'] ?? json['nama_hotel'] ?? '').toString(),
      alamat: (json['alamat'] ?? '').toString(),
      avgRating: _toDouble(json['avg_rating']),
      deskripsi: (json['deskripsi'] ?? '').toString(),
      imageUrls: imageUrls,
      rooms: rooms,
      facilities: _hotelFacilities(json['fasilitas'], rooms),
      hargaMulai: _startingPrice(json, rooms),
    );
  }

  String get name => nama;
  String get location => alamat;
  double get rating => avgRating;
  String? get imageUrl => _firstOrNull(imageUrls);
  int? get kapasitas => rooms.isEmpty
      ? null
      : rooms.map((room) => room.capacity).reduce((a, b) => a > b ? a : b);

  HotelModel copyWith({
    int? idHotel,
    String? nama,
    String? alamat,
    double? avgRating,
    String? deskripsi,
    List<String>? imageUrls,
    List<RoomModel>? rooms,
    List<String>? facilities,
    String? hargaMulai,
  }) {
    return HotelModel(
      idHotel: idHotel ?? this.idHotel,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      avgRating: avgRating ?? this.avgRating,
      deskripsi: deskripsi ?? this.deskripsi,
      imageUrls: imageUrls ?? this.imageUrls,
      rooms: rooms ?? this.rooms,
      facilities: facilities ?? this.facilities,
      hargaMulai: hargaMulai ?? this.hargaMulai,
    );
  }

  static List<String> _photoUrls(dynamic photos) {
    if (photos is! List) return [];

    return photos
        .where((photo) => photo is Map)
        .map((photo) => (photo as Map)['url_foto']?.toString())
        .map(_resolveUrl)
        .whereType<String>()
        .toList();
  }

  static List<RoomModel> _roomList(dynamic rooms, String? fallbackImageUrl) {
    if (rooms is! List) return [];

    return rooms
        .where((room) => room is Map)
        .map(
          (room) => RoomModel.fromJson(
            Map<String, dynamic>.from(room as Map),
            fallbackImageUrl: fallbackImageUrl,
          ),
        )
        .toList();
  }

  static List<String> _hotelFacilities(
    dynamic rawFacilities,
    List<RoomModel> rooms,
  ) {
    final facilities = <String>{};

    if (rawFacilities is List) {
      for (final item in rawFacilities) {
        if (item is Map) {
          final name = item['nama_fasilitas'] ?? item['name'] ?? item['nama'];
          if (name != null) facilities.add(name.toString());
        } else if (item != null) {
          facilities.add(item.toString());
        }
      }
    }

    for (final room in rooms) {
      facilities.addAll(room.facilities);
    }

    return facilities.toList();
  }

  static String? _startingPrice(
    Map<String, dynamic> json,
    List<RoomModel> rooms,
  ) {
    final directAmount = _toInt(json['harga_mulai'] ?? json['harga_per_malam']);

    if (directAmount != null) {
      return _formatRupiah(directAmount);
    }

    if (rooms.isEmpty) return null;

    final prices = rooms.map((room) => room.price).where((price) => price > 0);

    if (prices.isEmpty) return null;

    return _formatRupiah(prices.reduce((a, b) => a < b ? a : b));
  }

  static String? _resolveUrl(String? rawUrl) {
    final url = rawUrl?.trim();

    if (url == null || url.isEmpty) return null;

    final uri = Uri.tryParse(url);

    if (uri != null && uri.hasScheme) return url;

    final apiUri = Uri.parse(ApiConfig.baseUrl);
    final path = url.startsWith('/') ? url : '/$url';

    return '${apiUri.scheme}://${apiUri.authority}$path';
  }

  static String? _firstOrNull(List<String> values) {
    return values.isEmpty ? null : values.first;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    final text = value.toString().trim();
    final direct = int.tryParse(text);

    if (direct != null) return direct;

    // Tangani string desimal seperti "1500000.00" agar tidak salah baca
    // menjadi 150000000 saat titik/koma dihapus.
    final asDouble = double.tryParse(text.replaceAll(',', '.'));
    if (asDouble != null) return asDouble.toInt();

    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return null;

    return int.tryParse(digits);
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  static String _formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'IDR $formatted';
  }
}

class RoomModel {
  final int idRoom;
  final String name;
  final int price;
  final int capacity;
  final String bedType;
  final double roomSize;
  final String imageUrl;
  final String status;
  final List<String> facilities;

  RoomModel({
    required this.idRoom,
    required this.name,
    required this.price,
    required this.capacity,
    required this.bedType,
    required this.roomSize,
    required this.imageUrl,
    required this.status,
    this.facilities = const [],
  });

  factory RoomModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackImageUrl,
  }) {
    final roomName = (json['tipe_kamar'] ??
            json['nama_kamar'] ??
            json['name'] ??
            'Kamar ${json['nomor_kamar'] ?? ''}')
        .toString()
        .trim();

    return RoomModel(
      idRoom: HotelModel._toInt(json['id_kamar'] ?? json['id_room']) ?? 0,
      name: roomName.isEmpty ? 'Kamar' : roomName,
      price: HotelModel._toInt(json['harga_per_malam'] ?? json['price']) ?? 0,
      capacity: HotelModel._toInt(json['kapasitas'] ?? json['capacity']) ?? 1,
      bedType: (json['bed_type'] ?? json['tipe_bed'] ?? json['tipe_kamar'] ?? '-')
          .toString(),
      roomSize:
          HotelModel._toDouble(json['luas_kamar'] ?? json['room_size'] ?? 24),
      imageUrl: HotelModel._resolveUrl(_firstRoomPhoto(json['foto'])) ??
          fallbackImageUrl ??
          '',
      status: (json['status'] ?? '').toString(),
      facilities: _facilityNames(json['fasilitas']),
    );
  }

  RoomModel copyWith({
    int? idRoom,
    String? name,
    int? price,
    int? capacity,
    String? bedType,
    double? roomSize,
    String? imageUrl,
    String? status,
    List<String>? facilities,
  }) {
    return RoomModel(
      idRoom: idRoom ?? this.idRoom,
      name: name ?? this.name,
      price: price ?? this.price,
      capacity: capacity ?? this.capacity,
      bedType: bedType ?? this.bedType,
      roomSize: roomSize ?? this.roomSize,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      facilities: facilities ?? this.facilities,
    );
  }

  static String? _firstRoomPhoto(dynamic photos) {
    if (photos is List && photos.isNotEmpty) {
      final firstPhoto = photos.first;

      if (firstPhoto is Map) {
        return firstPhoto['url_foto']?.toString();
      }
    }

    if (photos is Map) {
      return photos['url_foto']?.toString();
    }

    return null;
  }

  static List<String> _facilityNames(dynamic rawFacilities) {
    if (rawFacilities is! List) return [];

    return rawFacilities
        .map((facility) {
          if (facility is Map) {
            return facility['nama_fasilitas'] ??
                facility['name'] ??
                facility['nama'];
          }

          return facility;
        })
        .where((facility) => facility != null)
        .map((facility) => facility.toString())
        .toList();
  }
}
