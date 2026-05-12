import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: AppColors.bodyText,
          disabledBackgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        label: const Text(
          'Masuk dengan Google',
          style: TextStyle(
            color: AppColors.bodyText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
