import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'primary_button.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    required this.onStart,
    this.title = 'Akun Anda Sudah Siap!',
    this.message =
        'Selamat bergabung! Akun Anda telah berhasil dibuat dan dikonfigurasi.',
    this.buttonLabel = 'Ayo Mulai!',
    super.key,
  });

  final VoidCallback onStart;
  final String title;
  final String message;
  final String buttonLabel;

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
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.bodyText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: buttonLabel, onPressed: onStart),
          ],
        ),
      ),
    );
  }
}
