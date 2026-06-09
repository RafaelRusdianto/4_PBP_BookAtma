import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../models/search_filter_model.dart';
import '../../services/search_service.dart';

class SearchPage extends StatefulWidget {
  final SearchFilterModel? initialFilter;

  const SearchPage({
    super.key,
    this.initialFilter,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchFilterModel filter = const SearchFilterModel();
  Future<List<HotelModel>>? searchFuture;
  bool hasSearched = false;
  bool loadingLocation = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialFilter != null) {
      _runSearch(widget.initialFilter!);
    }
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialFilter != null &&
        widget.initialFilter != oldWidget.initialFilter) {
      _runSearch(widget.initialFilter!);
    }
  }

  void _runSearch(SearchFilterModel newFilter) {
    setState(() {
      filter = newFilter;
      hasSearched = true;
      searchFuture = SearchService.searchHotels(newFilter);
    });
  }

  void _resetSearch() {
    setState(() {
      filter = const SearchFilterModel();
      hasSearched = false;
      searchFuture = null;
    });
  }

  Future<void> _openSearchSheet() async {
    final keywordController = TextEditingController(text: filter.keyword);
    DateTime? tempCheckIn = filter.checkIn;
    DateTime? tempCheckOut = filter.checkOut;
    int tempGuests = filter.guests;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 22,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Cari Hotel',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: keywordController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama kota atau hotel',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF1F3FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 2),
                        initialDateRange:
                            tempCheckIn != null && tempCheckOut != null
                                ? DateTimeRange(
                                    start: tempCheckIn!,
                                    end: tempCheckOut!,
                                  )
                                : null,
                      );

                      if (picked != null) {
                        setModalState(() {
                          tempCheckIn = picked.start;
                          tempCheckOut = picked.end;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderInput),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              SearchFilterModel(
                                checkIn: tempCheckIn,
                                checkOut: tempCheckOut,
                              ).dateText,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderInput),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Jumlah Tamu',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _CounterButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (tempGuests > 1) {
                              setModalState(() {
                                tempGuests--;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '$tempGuests',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _CounterButton(
                          icon: Icons.add,
                          active: true,
                          onTap: () {
                            setModalState(() {
                              tempGuests++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        final newFilter = SearchFilterModel(
                          keyword: keywordController.text.trim(),
                          checkIn: tempCheckIn,
                          checkOut: tempCheckOut,
                          guests: tempGuests,
                        );

                        Navigator.pop(context);
                        _runSearch(newFilter);
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    keywordController.dispose();
  }

  Future<void> _useCurrentLocation() async {
    try {
      setState(() {
        loadingLocation = true;
      });

      final enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        throw Exception('Layanan lokasi belum aktif');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak');
      }

      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      final province = _cleanProvinceName(
        place?.administrativeArea ??
            place?.subAdministrativeArea ??
            place?.locality ??
            'Jakarta',
      );

      final newFilter = SearchFilterModel(
        keyword: province,
        currentProvince: province,
        useCurrentLocation: true,
        guests: filter.guests,
        checkIn: filter.checkIn,
        checkOut: filter.checkOut,
      );

      _runSearch(newFilter);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lokasi belum bisa diambil. Untuk sementara memakai Jakarta.',
          ),
        ),
      );

      _runSearch(
        SearchFilterModel(
          keyword: 'Jakarta',
          currentProvince: 'Jakarta',
          useCurrentLocation: true,
          guests: filter.guests,
          checkIn: filter.checkIn,
          checkOut: filter.checkOut,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loadingLocation = false;
        });
      }
    }
  }

  String _cleanProvinceName(String value) {
    final text = value.trim();

    if (text.toLowerCase().contains('jakarta')) return 'Jakarta';
    if (text.toLowerCase().contains('yogyakarta')) return 'Yogyakarta';
    if (text.toLowerCase().contains('jawa tengah')) return 'Semarang';
    if (text.toLowerCase().contains('jawa barat')) return 'Bandung';
    if (text.toLowerCase().contains('bali')) return 'Bali';

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: hasSearched ? _buildResultView() : _buildSearchHomeView(),
    );
  }

  Widget _buildSearchHomeView() {
    return Column(
      children: [
        _buildSearchHeader(),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: loadingLocation ? null : _useCurrentLocation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.navigation_rounded,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            loadingLocation
                                ? 'Mengambil Lokasi...'
                                : 'Gunakan Lokasi Saat Ini',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'DESTINASI POPULER',
                  style: TextStyle(
                    color: AppColors.placeholder,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 16),

                _DestinationItem(
                  title: 'Jakarta',
                  subtitle: 'DKI Jakarta, Indonesia',
                  onTap: () {
                    _runSearch(
                      const SearchFilterModel(keyword: 'Jakarta'),
                    );
                  },
                ),
                _DestinationItem(
                  title: 'Bali',
                  subtitle: 'Provinsi Bali, Indonesia',
                  onTap: () {
                    _runSearch(
                      const SearchFilterModel(keyword: 'Bali'),
                    );
                  },
                ),
                _DestinationItem(
                  title: 'Bandung',
                  subtitle: 'Jawa Barat, Indonesia',
                  onTap: () {
                    _runSearch(
                      const SearchFilterModel(keyword: 'Bandung'),
                    );
                  },
                ),
                _DestinationItem(
                  title: 'Yogyakarta',
                  subtitle: 'DI Yogyakarta, Indonesia',
                  onTap: () {
                    _runSearch(
                      const SearchFilterModel(keyword: 'Yogyakarta'),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: _openSearchSheet,
              child: Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppColors.accent,
                    width: 1.4,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.placeholder,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mau kemana?',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.placeholder,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: _resetSearch,
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Column(
      children: [
        _buildResultHeader(),

        Expanded(
          child: FutureBuilder<List<HotelModel>>(
            future: searchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }

              final hotels = snapshot.data ?? [];

              if (hotels.isEmpty) {
                return const Center(
                  child: Text(
                    'Hotel tidak ditemukan',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                itemBuilder: (context, index) {
                  return _SearchResultCard(
                    hotel: hotels[index],
                    guestCount: filter.guests,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 22);
                },
                itemCount: hotels.length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeader() {
    final titleText = filter.useCurrentLocation
        ? 'Anda Berada Di ${filter.currentProvince ?? filter.keyword}'
        : 'Pencarian Anda';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _resetSearch,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white.withOpacity(0.18),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _openSearchSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      filter.summaryText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DestinationItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.placeholder,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final HotelModel hotel;
  final int guestCount;

  const _SearchResultCard({
    required this.hotel,
    required this.guestCount,
  });

  @override
  Widget build(BuildContext context) {
    final room = hotel.rooms.isEmpty
        ? null
        : hotel.rooms.firstWhere(
            (item) => item.capacity >= guestCount,
            orElse: () => hotel.rooms.first,
          );

    final imageUrl = hotel.imageUrl ?? room?.imageUrl ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/hotel-detail',
          arguments: hotel,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Stack(
              children: [
                imageUrl.isEmpty
                    ? Container(
                        height: 210,
                        width: double.infinity,
                        color: AppColors.secondary,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.placeholder,
                          size: 42,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        height: 210,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                Positioned(
                  left: 16,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'POPULER',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7D6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.accent,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
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
                        size: 17,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.placeholder,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.bed_outlined,
                                  color: AppColors.placeholder,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    room?.bedType ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.placeholder,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.people_alt_outlined,
                                  color: AppColors.placeholder,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '$guestCount Dewasa',
                                  style: const TextStyle(
                                    color: AppColors.placeholder,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'IDR',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: room == null
                                      ? '-'
                                      : _formatPrice(room.price),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const TextSpan(
                                  text: '/malam',
                                  style: TextStyle(
                                    color: AppColors.placeholder,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _CounterButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary),
        ),
        child: Icon(
          icon,
          color: active ? AppColors.white : AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}