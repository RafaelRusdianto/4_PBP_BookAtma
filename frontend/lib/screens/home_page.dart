import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> hotels = const [
    {
      'name': 'Hotel Santika',
      'location': 'Yogyakarta',
      'price': 350000,
      'rating': 4.5,
    },
    {
      'name': 'Hotel Melati Indah',
      'location': 'Sleman',
      'price': 250000,
      'rating': 4.2,
    },
    {
      'name': 'Grand Atma Hotel',
      'location': 'Bantul',
      'price': 500000,
      'rating': 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Hotel'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.hotel),
              title: Text(hotel['name']),
              subtitle: Text(
                '${hotel['location']} \nRp ${hotel['price']} / malam\nRating: ${hotel['rating']}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}