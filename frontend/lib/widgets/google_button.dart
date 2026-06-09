import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.label = 'Masuk dengan Google',
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.bodyText,
          disabledForegroundColor: AppColors.bodyText,
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
        label: Text(
          isLoading ? 'Memproses...' : label,
          style: const TextStyle(
            color: AppColors.bodyText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
