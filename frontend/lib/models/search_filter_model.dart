class SearchFilterModel {
  final String keyword;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;
  final bool useCurrentLocation;
  final String? currentProvince;

  const SearchFilterModel({
    this.keyword = '',
    this.checkIn,
    this.checkOut,
    this.guests = 2,
    this.useCurrentLocation = false,
    this.currentProvince,
  });

  SearchFilterModel copyWith({
    String? keyword,
    DateTime? checkIn,
    DateTime? checkOut,
    int? guests,
    bool? useCurrentLocation,
    String? currentProvince,
  }) {
    return SearchFilterModel(
      keyword: keyword ?? this.keyword,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      guests: guests ?? this.guests,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
      currentProvince: currentProvince ?? this.currentProvince,
    );
  }

  Map<String, String> toQueryParameters() {
    final query = <String, String>{};

    if (keyword.trim().isNotEmpty) {
      query['keyword'] = keyword.trim();
    }

    if (checkIn != null) {
      query['check_in'] = _formatApiDate(checkIn!);
    }

    if (checkOut != null) {
      query['check_out'] = _formatApiDate(checkOut!);
    }

    query['guest'] = guests.toString();

    if (useCurrentLocation && currentProvince != null) {
      query['current_province'] = currentProvince!;
    }

    return query;
  }

  String get dateText {
    if (checkIn == null && checkOut == null) {
      return 'Pilih tang...';
    }

    if (checkIn != null && checkOut == null) {
      return _formatShortDate(checkIn!);
    }

    if (checkIn == null && checkOut != null) {
      return _formatShortDate(checkOut!);
    }

    return '${_formatShortDate(checkIn!)} - ${_formatShortDate(checkOut!)}';
  }

  String get guestText {
    return '$guests Dewasa...';
  }

  String get summaryText {
    final locationText = keyword.trim().isEmpty ? 'Semua Lokasi' : keyword.trim();
    return '$locationText • $dateText • $guests Dewasa...';
  }

  static String _formatApiDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}