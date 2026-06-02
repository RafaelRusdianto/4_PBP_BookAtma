import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/book_atma_logo.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
          child: Column(
            children: [
              const BookAtmaLogo(size: 72),

              const SizedBox(height: 24),

              const Text(
                'Cari Hotel Favoritmu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.bodyText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Temukan penginapan terbaik dengan harga spesial.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mutedText, fontSize: 13),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Masuk',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                },
              ),

              const SizedBox(height: 12),

              SecondaryButton(
                label: 'Daftar',
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.register);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
