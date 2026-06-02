import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'primary_button.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 34,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Akun Anda Sudah Siap!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.bodyText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selamat bergabung! Akun Anda telah berhasil dibuat dan dikonfigurasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Ayo Mulai!', onPressed: onStart),
          ],
        ),
      ),
    );
  }
}
