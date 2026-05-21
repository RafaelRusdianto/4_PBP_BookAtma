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
      idHotel: json['id_hotel'],
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      avgRating: double.tryParse(json['avg_rating'].toString()) ?? 0.0,
      deskripsi: json['deskripsi'] ?? '',
      imageUrl: json['url_foto'],
      kapasitas: int.tryParse(json['kapasitas'].toString()),
      hargaMulai: json['harga_mulai']?.toString(),
    );
  }
}
