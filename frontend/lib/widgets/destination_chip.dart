import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class DestinationChip extends StatelessWidget {
  final String name;
  final String code;
  final IconData icon;
  final VoidCallback onTap;

  const DestinationChip({
    super.key,
    required this.name,
    required this.code,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.softBlue,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.bodyText,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              code,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
