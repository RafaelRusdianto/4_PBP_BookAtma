import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BookAtma')),
      body: const Center(
        child: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.bodyText,
          ),
        ),
      ),
    );
  }
}
