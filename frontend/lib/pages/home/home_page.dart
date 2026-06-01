// import 'package:flutter/material.dart';

// import '../../core/theme/app_colors.dart';

// final List<Map<String, dynamic>> hotelRecommendations = [
//   {
//     'image':
//         'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=900',
//     'name': 'The Ritz - Carlton Jakarta',
//     'location': 'Menteng, Jakarta Pusat',
//     'bed': 3,
//     'guest': 4,
//     'rating': 4.7,
//     'price': 940000,
//   },
//   {
//     'image':
//         'https://images.unsplash.com/photo-1501117716987-c8e5cae45ed3?w=900',
//     'name': 'Kimpton Bangkok',
//     'location': 'Bangkok, Thailand',
//     'bed': 2,
//     'guest': 2,
//     'rating': 4.9,
//     'price': 120000,
//   },
//   {
//     'image':
//         'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=900',
//     'name': 'Mandarin Oriental',
//     'location': 'Singapore',
//     'bed': 2,
//     'guest': 3,
//     'rating': 4.8,
//     'price': 260000,
//   },
//   {
//     'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=900',
//     'name': 'Bali Beach Resort',
//     'location': 'Bali, Indonesia',
//     'bed': 2,
//     'guest': 4,
//     'rating': 4.6,
//     'price': 180000,
//   },
//   {
//     'image':
//         'https://images.unsplash.com/photo-1494526585095-c41746248156?w=900',
//     'name': 'Yogyakarta Suites',
//     'location': 'Yogyakarta, Indonesia',
//     'bed': 1,
//     'guest': 2,
//     'rating': 4.5,
//     'price': 54000,
//   },
// ];

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.only(bottom: 100),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeader(),
//                   Transform.translate(
//                     offset: const Offset(0, -28),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18),
//                       child: _buildSearchBox(),
//                     ),
//                   ),
//                   Transform.translate(
//                     offset: const Offset(0, -12),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: _buildSectionHeader(),
//                     ),
//                   ),
//                   if (hotelRecommendations.isNotEmpty)
//                     Transform.translate(
//                       offset: const Offset(0, -4),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           children: hotelRecommendations
//                               .take(5)
//                               .map((hotel) => _HotelCard(hotel: hotel))
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Positioned(
//               left: 20,
//               right: 20,
//               bottom: 14,
//               child: _buildBottomNav(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       height: 210,
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(22, 20, 22, 34),
//       decoration: const BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             '9:30 PM',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 17,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, color: AppColors.primary, size: 20),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'WELCOME BACK,',
//                       style: TextStyle(color: Colors.white70, fontSize: 10),
//                     ),
//                     Text(
//                       'Alex Johnson',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 18,
//                 backgroundColor: Colors.white.withOpacity(0.18),
//                 child: const Icon(
//                   Icons.notifications_none_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           const Text(
//             'Mau ke mana hari ini?',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 25,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBox() {
//     return Container(
//       height: 66,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(34),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _SearchItem(title: 'LOKASI', value: 'Mau ke ma...'),
//           _SearchItem(title: 'TANGGAL', value: 'Pilih tang...'),
//           _SearchItem(title: 'TAMU &\nKAMAR', value: '2 Dewas...'),
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: CircleAvatar(
//               radius: 22,
//               backgroundColor: AppColors.primary,
//               child: const Icon(Icons.search, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: const [
//         Text(
//           'Rekomendasi',
//           style: TextStyle(
//             color: AppColors.bodyText,
//             fontSize: 16,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//         Text(
//           'Lihat Semua',
//           style: TextStyle(
//             color: AppColors.primary,
//             fontSize: 13,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomNav() {
//     return Container(
//       height: 62,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(32),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.home_rounded, color: Colors.white, size: 18),
//                 SizedBox(width: 6),
//                 Text(
//                   'Beranda',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.explore_outlined, color: AppColors.mutedText),
//           const Icon(Icons.receipt_long_outlined, color: AppColors.mutedText),
//           const Icon(Icons.person_outline, color: AppColors.mutedText),
//         ],
//       ),
//     );
//   }
// }

// class _SearchItem extends StatelessWidget {
//   const _SearchItem({required this.title, required this.value});

//   final String title;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: AppColors.mutedText,
//                 fontSize: 8,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 3),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: AppColors.bodyText,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w800,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HotelCard extends StatelessWidget {
//   const _HotelCard({required this.hotel});

//   final Map<String, dynamic> hotel;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 22),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 16,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 190,
//                 width: double.infinity,
//                 color: AppColors.softBlue,
//                 child: Image.network(
//                   hotel['image'],
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(AppColors.primary),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Center(
//                       child: Icon(
//                         Icons.image_not_supported_outlined,
//                         size: 40,
//                         color: AppColors.mutedText,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Positioned(
//                 left: 18,
//                 right: 18,
//                 bottom: 18,
//                 child: Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.55),
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         hotel['name'],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w900,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '📍 ${hotel['location']}',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
//             child: Row(
//               children: [
//                 const Icon(Icons.star, color: Colors.amber, size: 17),
//                 const SizedBox(width: 6),
//                 Text(
//                   hotel['rating'].toStringAsFixed(1),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w900,
//                     fontSize: 13,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   '(Review)',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.mutedText,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   _formatRupiah(hotel['price']),
//                   style: const TextStyle(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatRupiah(dynamic value) {
//     if (value == null) return 'Rp -';
//     final amount = value is num
//         ? value.toInt()
//         : int.tryParse(value.toString().replaceAll(RegExp('[^0-9]'), '')) ?? 0;
//     final formatted = amount.toString().replaceAllMapped(
//       RegExp(r'\B(?=(\d{3})+(?!\d))'),
//       (match) => '.',
//     );
//     return 'Rp $formatted';
//   }
// }

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../models/hotel_model.dart';
import '../../services/hotel_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<HotelModel>> hotelsFuture;
  int selectedNav = 0;

  @override
  void initState() {
    super.initState();
    hotelsFuture = HotelService.fetchHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<HotelModel>>(
        future: hotelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _HomeLoadingView();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final hotels = snapshot.data ?? [];

          if (hotels.isEmpty) {
            return const Center(
              child: Text('Data hotel kosong'),
            );
          }

          return _HomeContent(
            hotels: hotels,
            selectedNav: selectedNav,
            onNavTap: (index) {
              setState(() {
                selectedNav = index;
              });
            },
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<HotelModel> hotels;
  final int selectedNav;
  final Function(int index) onNavTap;

  const _HomeContent({
    required this.hotels,
    required this.selectedNav,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final hotel = hotels.first;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 52, 22, 30),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '9:30 PM',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.white,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME BACK,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Alex Johnson',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.notifications_none,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Mau ke mana hari ini?',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: _SearchItem(
                        title: 'LOKASI',
                        value: 'Mau ke mana?',
                      ),
                    ),
                    const Expanded(
                      child: _SearchItem(
                        title: 'TANGGAL',
                        value: 'Pilih tang...',
                      ),
                    ),
                    const Expanded(
                      child: _SearchItem(
                        title: 'TAMU & KAMAR',
                        value: '2 Dewasa...',
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Rekomendasi',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _HotelCard(
                    hotel: hotel,
                    room: hotel.rooms.first,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/hotel-detail',
                        arguments: hotel,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _HotelCard(
                    hotel: hotel,
                    room: hotel.rooms.last,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/hotel-detail',
                        arguments: hotel,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.borderInput),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(
                    icon: Icons.home,
                    label: 'Beranda',
                    active: selectedNav == 0,
                    onTap: () => onNavTap(0),
                  ),
                  _BottomNavItem(
                    icon: Icons.explore_outlined,
                    label: '',
                    active: selectedNav == 1,
                    onTap: () => onNavTap(1),
                  ),
                  _BottomNavItem(
                    icon: Icons.receipt_long_outlined,
                    label: '',
                    active: selectedNav == 2,
                    onTap: () => onNavTap(2),
                  ),
                  _BottomNavItem(
                    icon: Icons.person_outline,
                    label: '',
                    active: selectedNav == 3,
                    onTap: () => onNavTap(3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final String title;
  final String value;

  const _SearchItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.placeholder,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final RoomModel room;
  final VoidCallback onTap;

  const _HotelCard({
    required this.hotel,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  child: Image.network(
                    hotel.imageUrls.first,
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hotel.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${hotel.rating}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '(594)',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    FormatHelper.rupiah(room.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? AppColors.white : AppColors.placeholder,
              size: 18,
            ),
            if (active && label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            height: 210,
            width: double.infinity,
            color: const Color(0xFF475569),
            padding: const EdgeInsets.fromLTRB(22, 56, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '9:30 PM',
                  style: TextStyle(color: AppColors.white),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _skeletonCircle(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _skeletonBar(width: double.infinity),
                          const SizedBox(height: 8),
                          _skeletonBar(width: double.infinity),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _skeletonCircle(),
                  ],
                ),
                const SizedBox(height: 20),
                _skeletonBar(width: double.infinity, height: 28),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _loadingCard(),
                  const SizedBox(height: 18),
                  _loadingCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Spacer(),
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 18),
          Container(
            height: 58,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonCircle() {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFF94A3B8),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _skeletonBar({
    required double width,
    double height = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF94A3B8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}