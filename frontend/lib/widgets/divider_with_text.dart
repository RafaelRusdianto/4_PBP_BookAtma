import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
