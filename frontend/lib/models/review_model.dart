import '../config/api_config.dart';

class ReviewFotoItem {
  final int idReviewFoto;
  final String urlFoto;

  ReviewFotoItem({required this.idReviewFoto, required this.urlFoto});

  String get resolvedUrl => _resolveUrl(urlFoto);

  factory ReviewFotoItem.fromJson(Map<String, dynamic> json) {
    return ReviewFotoItem(
      idReviewFoto: (json['id_review_foto'] ?? 0) as int,
      urlFoto: (json['url_foto'] ?? '').toString(),
    );
  }

  static String _resolveUrl(String? rawUrl) {
    final url = rawUrl?.trim();
    if (url == null || url.isEmpty) return '';
    final uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme) return url;

    final apiUri = Uri.parse(ApiConfig.baseUrl);
    final cleanPath = url.startsWith('/') ? url.substring(1) : url;
    return '${apiUri.scheme}://${apiUri.authority}/storage/$cleanPath';
  }
}

class ReviewUser {
  final int idUser;
  final String nama;
  final String? fotoProfil;

  ReviewUser({required this.idUser, required this.nama, this.fotoProfil});

  String? get resolvedFotoProfil {
    final url = fotoProfil?.trim();
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme) return url;

    final apiUri = Uri.parse(ApiConfig.baseUrl);
    final cleanPath = url.startsWith('/') ? url.substring(1) : url;
    return '${apiUri.scheme}://${apiUri.authority}/storage/$cleanPath';
  }

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      idUser: (json['id_user'] ?? 0) as int,
      nama: (json['nama'] ?? '').toString(),
      fotoProfil: json['foto_profil']?.toString(),
    );
  }
}

class ReviewModel {
  final int idReview;
  final int idPembayaran;
  final int idHotel;
  final int rating;
  final String? keterangan;
  final String? createdAt;
  final String? updatedAt;
  final ReviewUser? user;
  final List<ReviewFotoItem> foto;

  ReviewModel({
    required this.idReview,
    required this.idPembayaran,
    required this.idHotel,
    required this.rating,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.foto = const [],
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    List<ReviewFotoItem> fotoList = [];
    if (json['foto'] is List) {
      fotoList = (json['foto'] as List)
          .whereType<Map>()
          .map((e) => ReviewFotoItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return ReviewModel(
      idReview: (json['id_review'] ?? 0) as int,
      idPembayaran: (json['id_pembayaran'] ?? 0) as int,
      idHotel: (json['id_hotel'] ?? 0) as int,
      rating: (json['rating'] ?? 0) as int,
      keterangan: json['keterangan']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] != null
          ? ReviewUser.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
      foto: fotoList,
    );
  }
}
