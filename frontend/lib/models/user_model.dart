class UserModel {
  final int id;
  final String email;
  final String nama;
  final String noHp;

  UserModel({
    required this.id,
    required this.email,
    required this.nama,
    required this.noHp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nama: json['nama'] ?? '',
      noHp: json['no_hp'] ?? '',
    );
  }
}
