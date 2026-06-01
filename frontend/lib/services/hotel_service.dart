import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/hotel_model.dart';

class HotelService {
  static Future<List<HotelModel>> fetchHotels() async {
    if (ApiConfig.useDummyData) {
      await Future.delayed(const Duration(seconds: 1));
      return dummyHotels;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/hotels'),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        return data.map((item) => HotelModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data hotel');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<HotelModel> dummyHotels = [
    HotelModel(
      id: 1,
      name: 'The Ritz-Carlton Jakarta',
      location: 'Menteng, Jakarta Pusat',
      description:
          'Hotel mewah dengan fasilitas lengkap, kamar nyaman, dan lokasi strategis di pusat Jakarta.',
      rating: 4.9,
      imageUrls: [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=900',
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=900',
        'https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=900',
      ],
      facilities: [
        'Free WiFi',
        'Pool',
        'Gym',
      ],
      rooms: [
        RoomModel(
          id: 1,
          hotelId: 1,
          name: 'Deluxe Double Room with Balcony',
          price: 1850000,
          imageUrl:
              'https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=900',
          capacity: 2,
          bedType: '1 King Bed',
          roomSize: 32,
          benefits: [
            'Breakfast for 2',
            'Free WiFi',
          ],
        ),
        RoomModel(
          id: 2,
          hotelId: 1,
          name: 'Executive Suite with Ocean View',
          price: 2450000,
          imageUrl:
              'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=900',
          capacity: 2,
          bedType: '1 Super King',
          roomSize: 48,
          benefits: [
            'Breakfast for 2',
            'Bathtub',
          ],
        ),
      ],
    ),
  ];
}