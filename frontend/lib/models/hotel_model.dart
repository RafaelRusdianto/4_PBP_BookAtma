import '../config/api_config.dart';

class HotelModel {
  final int idHotel;
  final String nama;
  final String alamat;
  final double avgRating;
  final String deskripsi;

  final String? imageUrl;
  final int? kapasitas;
  final String? hargaMulai;

  HotelModel({
    required this.idHotel,
    required this.nama,
    required this.alamat,
    required this.avgRating,
    required this.deskripsi,
    this.imageUrl,
    this.kapasitas,
    this.hargaMulai,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      idHotel: _toInt(json['id_hotel']) ?? 0,
      nama: (json['nama'] ?? json['nama_hotel'] ?? '').toString(),
      alamat: json['alamat'] ?? '',
      avgRating: _toDouble(json['avg_rating']),
      deskripsi: json['deskripsi'] ?? '',
      imageUrl: _resolveImageUrl(json['url_foto'] ?? _firstPhotoUrl(json)),
      kapasitas: _toInt(json['kapasitas']) ?? _maxRoomCapacity(json['kamar']),
      hargaMulai: _startingPrice(json),
    );
  }

  HotelModel copyWith({
    int? idHotel,
    String? nama,
    String? alamat,
    double? avgRating,
    String? deskripsi,
    String? imageUrl,
    int? kapasitas,
    String? hargaMulai,
  }) {
    return HotelModel(
      idHotel: idHotel ?? this.idHotel,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      avgRating: avgRating ?? this.avgRating,
      deskripsi: deskripsi ?? this.deskripsi,
      imageUrl: imageUrl ?? this.imageUrl,
      kapasitas: kapasitas ?? this.kapasitas,
      hargaMulai: hargaMulai ?? this.hargaMulai,
    );
  }

  static String? _firstPhotoUrl(Map<String, dynamic> json) {
    final photos = json['foto'];

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

  static String? _resolveImageUrl(dynamic value) {
    final url = value?.toString().trim();

    if (url == null || url.isEmpty) return null;

    final uri = Uri.tryParse(url);

    if (uri != null && uri.hasScheme) {
      return url;
    }

    final apiUri = Uri.parse(ApiConfig.baseUrl);
    final path = url.startsWith('/') ? url : '/$url';

    return '${apiUri.scheme}://${apiUri.authority}$path';
  }

  static String? _startingPrice(Map<String, dynamic> json) {
    final directPrice = json['harga_mulai'] ?? json['harga_per_malam'];
    final directAmount = _toInt(directPrice);

    if (directAmount != null) {
      return _formatRupiah(directAmount);
    }

    final rooms = json['kamar'];

    if (rooms is! List) return null;

    final prices = rooms
        .where((room) => room is Map)
        .map((room) => _toInt((room as Map)['harga_per_malam']))
        .whereType<int>()
        .toList();

    if (prices.isEmpty) return null;

    prices.sort();

    return _formatRupiah(prices.first);
  }

  static int? _maxRoomCapacity(dynamic rooms) {
    if (rooms is! List) return null;

    final capacities = rooms
        .where((room) => room is Map)
        .map((room) => _toInt((room as Map)['kapasitas']))
        .whereType<int>()
        .toList();

    if (capacities.isEmpty) return null;

    capacities.sort();

    return capacities.last;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    final text = value.toString().trim();
    final direct = int.tryParse(text);

    if (direct != null) return direct;

    final decimal = double.tryParse(text);

    if (decimal != null && RegExp(r'^\d+\.\d{1,2}$').hasMatch(text)) {
      return decimal.round();
    }

    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return null;

    return int.tryParse(digits);
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String _formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }
}
