import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class BackCircleButton extends StatelessWidget {
  const BackCircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).maybePop();
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.bodyText,
        shape: const CircleBorder(),
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
    );
  }
}
