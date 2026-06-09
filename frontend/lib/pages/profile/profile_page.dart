import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/api_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/setting_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _avatarFile;
  String? _avatarUrl;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Ambil data user yang sedang login (auth()->user()) dari backend.
  Future<void> _loadProfile() async {
    final user = await AuthService().getProfile();
    if (!mounted) return;

    setState(() {
      if (user != null) {
        _nameController.text = (user['nama'] ?? '').toString();
        _emailController.text = (user['email'] ?? '').toString();
        _phoneController.text = (user['no_hp'] ?? '').toString();
        _avatarUrl = _resolveFotoUrl(user['foto_profil']);
      }
      _isLoading = false;
    });
  }

  // Ubah path foto_profil dari backend menjadi URL lengkap yang bisa diakses.
  String? _resolveFotoUrl(dynamic foto) {
    final path = foto?.toString().trim();
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;

    final host = ApiConfig.baseUrl.replaceAll('/api', '');
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return '$host/storage/$clean';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return;
      setState(() {
        _avatarFile = File(picked.path);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih foto.')),
      );
    }
  }

void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ganti Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bodyText,
                ),
              ),
              const SizedBox(height: 18),

              _photoOptionTile(
                icon: Icons.camera_alt_outlined,
                title: 'Ambil Foto',
                subtitle: 'Gunakan kamera ponsel Anda',
                onTap: () async {
                  Navigator.of(context).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(ImageSource.camera);
                },
              ),

              const SizedBox(height: 12),

              _photoOptionTile(
                icon: Icons.photo_library_outlined,
                title: 'Pilih dari Galeri',
                subtitle: 'Cari foto dari penyimpanan',
                onTap: () async {
                  Navigator.of(context).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(ImageSource.gallery);
                },
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _photoOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodyText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.mutedText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Bantuan'),
          content: const Text(
            'Butuh bantuan? Hubungi layanan pelanggan di:\n\n' 
            'Email: cs@bookatma.com\n' 
            'Telepon: 0804-1-500-303\n\n' 
            'Atau kunjungi pengaturan untuk menyesuaikan pengalaman Anda.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bodyText,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Apakah Anda yakin ingin keluar? Sesi Anda akan berakhir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.mutedText, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    navigator.pop();
                    await AuthService().logout();
                    navigator.pushNamedAndRemoveUntil(
                      AppRoutes.landing,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Keluar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final result = await AuthService().updateProfile(
      nama: _nameController.text.trim(),
      email: _emailController.text.trim(),
      noHp: _phoneController.text.trim(),
      foto: _avatarFile,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      if (result['success'] == true && result['data'] is Map) {
        // Pakai foto terbaru dari server, hentikan preview file lokal.
        _avatarUrl = _resolveFotoUrl(result['data']['foto_profil']);
        _avatarFile = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['message']?.toString() ?? 'Perubahan profil telah disimpan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget avatar;
    if (_avatarFile != null) {
      avatar = ClipOval(
        child: Image.file(_avatarFile!, width: 110, height: 110, fit: BoxFit.cover),
      );
    } else if (_avatarUrl != null) {
      avatar = ClipOval(
        child: Image.network(
          _avatarUrl!,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.softBlue,
            child: Icon(Icons.person, size: 52, color: AppColors.primary),
          ),
        ),
      );
    } else {
      avatar = const CircleAvatar(
        radius: 55,
        backgroundColor: AppColors.softBlue,
        child: Icon(Icons.person, size: 52, color: AppColors.primary),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                padding: const EdgeInsets.only(top: 24, bottom: 30),
                child: Column(
                  children: [
                    const Text(
                      'Profil Saya',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        avatar,
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _showPhotoOptions,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_outlined, size: 20, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _nameController.text,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Lengkap',
                            ),
                            validator: (value) => value?.isEmpty == true ? 'Nama harus diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email harus diisi';
                              }
                              if (!value.contains('@')) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Nomor Telepon',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) => value?.isEmpty == true ? 'Nomor harus diisi' : null,
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                            onPressed: _isSaving ? null : _saveProfile,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SettingTile(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan',
                      subtitle: 'Kelola preferensi aplikasi',
                      trailing: const Icon(Icons.chevron_right, color: AppColors.mutedText),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.settings);
                      },
                    ),
                    const SizedBox(height: 14),
                    SettingTile(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      subtitle: 'Informasi dan dukungan',
                      trailing: const Icon(Icons.chevron_right, color: AppColors.mutedText),
                      onTap: _showHelpDialog,
                    ),
                    const SizedBox(height: 14),
                    SettingTile(
                      icon: Icons.logout_outlined,
                      title: 'Keluar Akun',
                      subtitle: 'Sesi Anda akan berakhir',
                      trailing: const Icon(Icons.chevron_right, color: AppColors.mutedText),
                      onTap: _showLogoutConfirmation,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
