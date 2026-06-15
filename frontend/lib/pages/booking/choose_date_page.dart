import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../core/format_helper.dart';
import '../../services/booking_service.dart';

class ChooseDatePage extends StatefulWidget {
  const ChooseDatePage({super.key});

  @override
  State<ChooseDatePage> createState() => _ChooseDatePageState();
}

class _ChooseDatePageState extends State<ChooseDatePage> {
  DateTime currentMonth = DateTime.now();
  DateTime? checkInDate = DateTime.now();
  DateTime? checkOutDate;
  final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String monthName(int month) {
    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }

  int totalNight() {
    if (checkInDate == null || checkOutDate == null) {
      return 0;
    }

    return checkOutDate!.difference(checkInDate!).inDays;
  }

  bool isDateDisabled(DateTime date) {
    return date.isBefore(today);
  }

  void selectDate(DateTime selectedDate) {
    if (isDateDisabled(selectedDate)) return;

    setState(() {
      if (checkInDate == null) {
        checkInDate = selectedDate;
        checkOutDate = null;
      } else if (checkOutDate == null) {
        if (selectedDate.isBefore(checkInDate!)) {
          checkInDate = selectedDate;
          checkOutDate = null;
        } else if (selectedDate.isAtSameMomentAs(checkInDate!)) {
          checkInDate = selectedDate;
          checkOutDate = null;
        } else {
          checkOutDate = selectedDate;
        }
      } else {
        checkInDate = selectedDate;
        checkOutDate = null;
      }
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
        1,
      );
    });
  }

  void previousMonth() {
    final newMonth = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
      1,
    );
    final todayMonthStart = DateTime(today.year, today.month, 1);
    if (newMonth.isBefore(todayMonthStart)) return;

    setState(() {
      currentMonth = newMonth;
    });
  }

  bool isSelectedDate(DateTime date) {
    bool isCheckIn = checkInDate != null &&
        date.year == checkInDate!.year &&
        date.month == checkInDate!.month &&
        date.day == checkInDate!.day;

    bool isCheckOut = checkOutDate != null &&
        date.year == checkOutDate!.year &&
        date.month == checkOutDate!.month &&
        date.day == checkOutDate!.day;

    return isCheckIn || isCheckOut;
  }

  bool isBetweenDate(DateTime date) {
    if (checkInDate == null || checkOutDate == null) {
      return false;
    }

    return date.isAfter(checkInDate!) && date.isBefore(checkOutDate!);
  }

  @override
  Widget build(BuildContext context) {
    bool canSave = checkInDate != null && checkOutDate != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
          color: AppColors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canSave
                          ? '${totalNight()} Malam'
                          : 'Tanggal belum dipilih',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      canSave
                          ? '${FormatHelper.shortDate(checkInDate)} - ${FormatHelper.shortDate(checkOutDate)}'
                          : 'Pilih check-in dan check-out',
                      style: const TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: canSave
                    ? () {
                        BookingService.setDates(
                          checkIn: checkInDate!,
                          checkOut: checkOutDate!,
                        );

                        Navigator.pushNamed(context, '/request-booking');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.borderInput,
                  minimumSize: const Size(115, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _AppBarTitle(
              title: 'Pilih Tanggal',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _DateInfo(
                              label: 'CHECK-IN',
                              value: FormatHelper.shortDate(checkInDate),
                              selected: checkInDate != null,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.placeholder,
                            size: 18,
                          ),
                          Expanded(
                            child: _DateInfo(
                              label: 'CHECK-OUT',
                              value: FormatHelper.shortDate(checkOutDate),
                              selected: checkOutDate != null,
                              alignRight: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          IconButton(
                            onPressed: previousMonth,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Expanded(
                            child: Text(
                              '${monthName(currentMonth.month)} ${currentMonth.year}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: nextMonth,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Row(
                        children: [
                          _DayName('Min'),
                          _DayName('Sen'),
                          _DayName('Sel'),
                          _DayName('Rab'),
                          _DayName('Kam'),
                          _DayName('Jum'),
                          _DayName('Sab'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _CalendarGrid(
                        month: currentMonth,
                        isSelectedDate: isSelectedDate,
                        isBetweenDate: isBetweenDate,
                        isDisabled: isDateDisabled,
                        onDateTap: selectDate,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Ketuk tanggal pertama untuk check-in, lalu ketuk tanggal kedua untuk check-out.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                    ],
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

class _AppBarTitle extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _AppBarTitle({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 20),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final bool alignRight;

  const _DateInfo({
    required this.label,
    required this.value,
    required this.selected,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.placeholder,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.placeholder,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _DayName extends StatelessWidget {
  final String text;

  const _DayName(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.placeholder,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final bool Function(DateTime date) isSelectedDate;
  final bool Function(DateTime date) isBetweenDate;
  final bool Function(DateTime date) isDisabled;
  final Function(DateTime date) onDateTap;

  const _CalendarGrid({
    required this.month,
    required this.isSelectedDate,
    required this.isBetweenDate,
    required this.isDisabled,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    int totalDays = DateTime(month.year, month.month + 1, 0).day;
    int firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    List<Widget> items = [];

    for (int i = 0; i < firstWeekday; i++) {
      items.add(const SizedBox());
    }

    for (int day = 1; day <= totalDays; day++) {
      DateTime date = DateTime(month.year, month.month, day);
      bool selected = isSelectedDate(date);
      bool between = isBetweenDate(date);
      bool disabled = isDisabled(date);

      items.add(
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: disabled ? null : () => onDateTap(date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : between
                      ? AppColors.secondary
                      : Colors.transparent,
              shape: selected ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: selected ? null : BorderRadius.circular(8),
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: disabled
                    ? AppColors.placeholder.withValues(alpha: 0.5)
                    : selected
                        ? AppColors.white
                        : AppColors.black,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    while (items.length % 7 != 0) {
      items.add(const SizedBox());
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      childAspectRatio: 1,
      children: items,
    );
  }
}