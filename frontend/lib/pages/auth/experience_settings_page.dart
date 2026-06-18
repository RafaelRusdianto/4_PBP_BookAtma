import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

import '../../widgets/back_circle_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/setting_tile.dart';
import '../../widgets/success_dialog.dart';

class ExperienceSettingsPage extends StatefulWidget {
  const ExperienceSettingsPage({super.key});

  @override
  State<ExperienceSettingsPage> createState() => _ExperienceSettingsPageState();
}

class _ExperienceSettingsPageState extends State<ExperienceSettingsPage> {
  String _selectedLanguage = 'Bahasa Indonesia';

  bool _notificationsEnabled = true;

  Future<void> _saveSettings() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          onStart: () {
            Navigator.of(context).pop();

            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackCircleButton(),

              const SizedBox(height: 36),

              const Text(
                'Atur Pengalamanmu',
                style: TextStyle(
                  color: AppColors.bodyText,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 28),

              SettingTile(
                icon: Icons.language,
                title: 'Bahasa',
                subtitle: 'Pilih bahasa aplikasi',
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: const [
                    DropdownMenuItem(
                      value: 'Bahasa Indonesia',
                      child: Text('Bahasa Indonesia'),
                    ),
                    DropdownMenuItem(value: 'English', child: Text('English')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 14),

              SettingTile(
                icon: Icons.notifications_none,
                title: 'Notifikasi',
                subtitle: 'Aktifkan notifikasi',
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),

              const Spacer(),

              PrimaryButton(label: 'Simpan', onPressed: _saveSettings),
            ],
          ),
        ),
      ),
    );
  }
}
