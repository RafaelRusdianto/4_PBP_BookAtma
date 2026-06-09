import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../models/search_filter_model.dart';
import '../../services/hotel_service.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<SearchFilterModel>? onSearchSubmitted;

  const HomePage({
    super.key,
    this.onSearchSubmitted,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<HotelModel>> hotelsFuture;

  String searchKeyword = '';
  DateTime? checkIn;
  DateTime? checkOut;
  int guests = 2;

  @override
  void initState() {
    super.initState();
    hotelsFuture = HotelService.fetchHotels(limit: 5);
  }

  String get locationText {
    return searchKeyword.trim().isEmpty ? 'Mau ke mana?' : searchKeyword.trim();
  }

  String get dateText {
    return SearchFilterModel(
      checkIn: checkIn,
      checkOut: checkOut,
    ).dateText;
  }

  String get guestText {
    return '$guests Dewasa...';
  }

  Future<void> _openSearchSheet() async {
    final filter = await showModalBottomSheet<SearchFilterModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _HomeSearchSheet(
          initialKeyword: searchKeyword,
          initialCheckIn: checkIn,
          initialCheckOut: checkOut,
          initialGuests: guests,
        );
      },
    );

    if (!mounted || filter == null) return;

    setState(() {
      searchKeyword = filter.keyword;
      checkIn = filter.checkIn;
      checkOut = filter.checkOut;
      guests = filter.guests;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onSearchSubmitted?.call(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              Transform.translate(
                offset: const Offset(0, -24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSearchBox(),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Rekomendasi',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildRecommendationList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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

          const SizedBox(height: 26),

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
    );
  }

  Widget _buildSearchBox() {
    return Container(
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
          Expanded(
            child: GestureDetector(
              onTap: _openSearchSheet,
              child: _SearchItem(
                title: 'LOKASI',
                value: locationText,
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: _openSearchSheet,
              child: _SearchItem(
                title: 'TANGGAL',
                value: dateText,
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: _openSearchSheet,
              child: _SearchItem(
                title: 'TAMU & KAMAR',
                value: guestText,
              ),
            ),
          ),

          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              onPressed: _openSearchSheet,
              icon: const Icon(
                Icons.search,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationList() {
    return FutureBuilder<List<HotelModel>>(
      future: hotelsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _HomeLoadingView();
        }

        if (snapshot.hasError) {
          return _EmptyState(message: snapshot.error.toString());
        }

        final hotels = snapshot.data ?? [];

        if (hotels.isEmpty) {
          return const _EmptyState(message: 'Data hotel kosong');
        }

        return Column(
          children: hotels
              .map(
                (hotel) => _HotelCard(
                  hotel: hotel,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/hotel-detail',
                      arguments: hotel,
                    );
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _HomeSearchSheet extends StatefulWidget {
  final String initialKeyword;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final int initialGuests;

  const _HomeSearchSheet({
    required this.initialKeyword,
    required this.initialCheckIn,
    required this.initialCheckOut,
    required this.initialGuests,
  });

  @override
  State<_HomeSearchSheet> createState() => _HomeSearchSheetState();
}

class _HomeSearchSheetState extends State<_HomeSearchSheet> {
  late final TextEditingController keywordController;

  DateTime? tempCheckIn;
  DateTime? tempCheckOut;
  late int tempGuests;

  @override
  void initState() {
    super.initState();

    keywordController = TextEditingController(
      text: widget.initialKeyword,
    );

    tempCheckIn = widget.initialCheckIn;
    tempCheckOut = widget.initialCheckOut;
    tempGuests = widget.initialGuests;
  }

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDateRange: tempCheckIn != null && tempCheckOut != null
          ? DateTimeRange(
              start: tempCheckIn!,
              end: tempCheckOut!,
            )
          : null,
    );

    if (!mounted || picked == null) return;

    setState(() {
      tempCheckIn = picked.start;
      tempCheckOut = picked.end;
    });
  }

  void _submit() {
    final filter = SearchFilterModel(
      keyword: keywordController.text.trim(),
      checkIn: tempCheckIn,
      checkOut: tempCheckOut,
      guests: tempGuests,
    );

    Navigator.of(context).pop(filter);
  }

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextField(
              controller: keywordController,
              decoration: InputDecoration(
                hintText: 'Masukkan lokasi atau nama hotel',
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
              onTap: _pickDateRange,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jumlah Tamu',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Adults',
                          style: TextStyle(
                            color: AppColors.placeholder,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _HomeCounterButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (tempGuests <= 1) return;

                      setState(() {
                        tempGuests--;
                      });
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

                  _HomeCounterButton(
                    icon: Icons.add,
                    active: true,
                    onTap: () {
                      setState(() {
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
                onPressed: _submit,
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
    return Padding(
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
  final VoidCallback onTap;

  const _HotelCard({
    required this.hotel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: 210,
              width: double.infinity,
              child: _NetworkHotelImage(imageUrl: hotel.imageUrl),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textDisabled,
                        size: 15,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          hotel.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.accent,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        hotel.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        hotel.hargaMulai ?? 'Harga belum tersedia',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
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
}

class _NetworkHotelImage extends StatelessWidget {
  final String? imageUrl;

  const _NetworkHotelImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const _ImagePlaceholder();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ImagePlaceholder();
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.secondary,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: AppColors.placeholder,
        ),
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          height: 270,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderInput),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textDisabled,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HomeCounterButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _HomeCounterButton({
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
          border: Border.all(
            color: AppColors.primary,
          ),
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