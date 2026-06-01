class RoomModel {
  final int id;
  final int hotelId;
  final String name;
  final int price;
  final String imageUrl;
  final int capacity;
  final String bedType;
  final double roomSize;
  final List<String> benefits;

  RoomModel({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.capacity,
    required this.bedType,
    required this.roomSize,
    required this.benefits,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? 0,
      hotelId: json['hotel_id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      capacity: json['capacity'] ?? 0,
      bedType: json['bed_type'] ?? '',
      roomSize: double.tryParse(json['room_size'].toString()) ?? 0,
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'capacity': capacity,
      'bed_type': bedType,
      'room_size': roomSize,
      'benefits': benefits,
    };
  }
}

class HotelModel {
  final int id;
  final String name;
  final String location;
  final String description;
  final double rating;
  final List<String> imageUrls;
  final List<String> facilities;
  final List<RoomModel> rooms;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.imageUrls,
    required this.facilities,
    required this.rooms,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      rooms: (json['rooms'] as List? ?? [])
          .map((room) => RoomModel.fromJson(room))
          .toList(),
    );
  }
}