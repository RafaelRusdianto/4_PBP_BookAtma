import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class BookAtmaLogo extends StatelessWidget {
  const BookAtmaLogo({this.size = 64, this.showTagline = false, super.key});

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(size * 0.28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.bed_outlined,
                color: Colors.white,
                size: size * 0.56,
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.2,
                height: size * 0.2,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'BookAtma',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          const Text(
            'Booking hotel cepat & nyaman',
            style: TextStyle(color: AppColors.mutedText, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
