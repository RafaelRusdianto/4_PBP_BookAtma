import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../models/hotel_model.dart';
import '../../models/search_filter_model.dart';
import '../../services/booking_service.dart';

class DetailHotelPageArguments {
  final HotelModel hotel;
  final SearchFilterModel? searchFilter;

  const DetailHotelPageArguments({required this.hotel, this.searchFilter});
}

class DetailHotelPage extends StatefulWidget {
  const DetailHotelPage({super.key});

  @override
  State<DetailHotelPage> createState() => _DetailHotelPageState();
}

class _DetailHotelPageState extends State<DetailHotelPage> {
  int currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final HotelModel? hotel;
    final SearchFilterModel? searchFilter;

    if (args is DetailHotelPageArguments) {
      hotel = args.hotel;
      searchFilter = args.searchFilter;
    } else if (args is HotelModel) {
      hotel = args;
      searchFilter = null;
    } else {
      hotel = null;
      searchFilter = null;
    }

    if (hotel == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Detail Hotel')),
        body: const Center(child: Text('Data hotel belum tersedia')),
      );
    }

    final selectedHotel = hotel;
    final selectedCheckIn = searchFilter?.checkIn;
    final selectedCheckOut = searchFilter?.checkOut;

    double imageHeight = MediaQuery.of(context).size.height * 0.36;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: imageHeight,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: selectedHotel.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentImage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          selectedHotel.imageUrls[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.35),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 18,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          selectedHotel.imageUrls.length,
                          (index) => Container(
                            width: currentImage == index ? 18 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: currentImage == index
                                  ? AppColors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -26),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedHotel.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${selectedHotel.rating}/5)',
                            style: const TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.placeholder,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              selectedHotel.location,
                              style: const TextStyle(
                                color: AppColors.textDisabled,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: selectedHotel.facilities.map((facility) {
                          IconData icon = Icons.check_circle_outline;

                          if (facility.toLowerCase().contains('wifi')) {
                            icon = Icons.wifi;
                          } else if (facility.toLowerCase().contains('pool')) {
                            icon = Icons.pool;
                          } else if (facility.toLowerCase().contains('gym')) {
                            icon = Icons.fitness_center;
                          }

                          return _FacilityChip(icon: icon, text: facility);
                        }).toList(),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          const Text(
                            'Review Tamu',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 95,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _ReviewCard(
                              name: 'Andi Pratama',
                              text:
                                  'Kamar sangat bersih dan nyaman. Pelayanan staf sangat ramah!',
                            ),
                            SizedBox(width: 10),
                            _ReviewCard(
                              name: 'Siska',
                              text:
                                  'Sarapan lengkap dan lokasinya sangat strategis.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'Kamar Tersedia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 14),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedHotel.rooms.length,
                        itemBuilder: (context, index) {
                          final room = selectedHotel.rooms[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _RoomCard(
                              room: room,
                              onPressed: () {
                                BookingService.startBooking(
                                  hotel: selectedHotel,
                                  room: room,
                                );

                                if (selectedCheckIn != null &&
                                    selectedCheckOut != null) {
                                  BookingService.setDates(
                                    checkIn: selectedCheckIn,
                                    checkOut: selectedCheckOut,
                                  );

                                  Navigator.pushNamed(
                                    context,
                                    '/request-booking',
                                  );
                                  return;
                                }

                                Navigator.pushNamed(context, '/choose-date');
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FacilityChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String text;

  const _ReviewCard({required this.name, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.accent,
            child: Icon(Icons.person, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onPressed;

  const _RoomCard({required this.room, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderInput),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  room.imageUrl,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PROMO TERBATAS',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _SmallRoomInfo(
                      icon: Icons.person_outline,
                      text: '${room.capacity} Tamu',
                    ),
                    _SmallRoomInfo(
                      icon: Icons.bed_outlined,
                      text: room.bedType,
                    ),
                    _SmallRoomInfo(
                      icon: Icons.square_foot,
                      text: '${room.roomSize.toStringAsFixed(0)} m²',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        FormatHelper.rupiah(room.price),
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Pilih Tanggal',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallRoomInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallRoomInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.placeholder),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.textDisabled),
        ),
      ],
    );
  }
}
