import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/api_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/primary_button.dart';

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
  bool _isEditing = false;

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

    final clean = path.startsWith('/') ? path.substring(1) : path;

    // Foto hotel & kamar dari Supabase Storage
    if (clean.startsWith('hotels/') || clean.startsWith('rooms/')) {
      return '${ApiConfig.supabaseStorageUrl}/$clean';
    }

    // Fallback: Railway storage
    final host = ApiConfig.baseUrl.replaceAll('/api', '');
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memilih foto.')));
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

  void _openHelpCenter() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const _HelpCenterPage()));
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
                  child: Icon(Icons.logout, color: AppColors.primary, size: 30),
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedText,
                  height: 1.5,
                ),
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
        _isEditing = false;
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: _isEditing ? 34 : 18),
                child: Column(
                  children: [
                    _ProfileHeader(
                      avatar: _buildAvatar(_isEditing ? 96 : 110),
                      name: _nameController.text,
                      email: _emailController.text,
                      isEditing: _isEditing,
                      onBack: () => setState(() => _isEditing = false),
                      onChangePhoto: _showPhotoOptions,
                      onNotificationTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.notification),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _isEditing
                          ? _buildEditContent()
                          : _buildProfileContent(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatar(double size) {
    if (_avatarFile != null) {
      return ClipOval(
        child: Image.file(
          _avatarFile!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          _avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => CircleAvatar(
            radius: size / 2,
            backgroundColor: AppColors.softBlue,
            child: Icon(
              Icons.person,
              size: size * 0.48,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.softBlue,
      child: Icon(Icons.person, size: size * 0.48, color: AppColors.primary),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      key: const ValueKey('profile-menu'),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 10),
      child: Column(
        children: [
          _ProfileMenuTile(
            icon: Icons.person_outline,
            iconColor: AppColors.primary,
            iconBackground: AppColors.softBlue,
            title: 'Edit Profil',
            onTap: () => setState(() => _isEditing = true),
          ),
          const SizedBox(height: 16),
          _ProfileMenuTile(
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF7C6BFF),
            iconBackground: const Color(0xFFEDEBFF),
            title: 'Pengaturan',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
          const SizedBox(height: 16),
          _ProfileMenuTile(
            icon: Icons.help_outline,
            iconColor: AppColors.success,
            iconBackground: const Color(0xFFE8FFF3),
            title: 'Bantuan',
            onTap: _openHelpCenter,
          ),
          const SizedBox(height: 16),
          _ProfileMenuTile(
            icon: Icons.logout_outlined,
            iconColor: AppColors.danger,
            iconBackground: const Color(0xFFFFECEC),
            title: 'Keluar Akun',
            titleColor: AppColors.danger,
            backgroundColor: const Color(0xFFFFF1F1),
            showChevron: false,
            onTap: _showLogoutConfirmation,
          ),
        ],
      ),
    );
  }

  Widget _buildEditContent() {
    return Padding(
      key: const ValueKey('edit-form'),
      padding: const EdgeInsets.fromLTRB(34, 0, 34, 0),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _ProfileTextField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      validator: (value) =>
                          value?.isEmpty == true ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    _ProfileTextField(
                      controller: _emailController,
                      label: 'Email',
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
                    _ProfileTextField(
                      controller: _phoneController,
                      label: 'Nomor Telepon',
                      keyboardType: TextInputType.phone,
                      prefixText: '+62  ',
                      validator: (value) =>
                          value?.isEmpty == true ? 'Nomor harus diisi' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 38),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: PrimaryButton(
              label: _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
              onPressed: _isSaving ? null : _saveProfile,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.avatar,
    required this.name,
    required this.email,
    required this.isEditing,
    required this.onBack,
    required this.onChangePhoto,
    required this.onNotificationTap,
  });

  final Widget avatar;
  final String name;
  final String email;
  final bool isEditing;
  final VoidCallback onBack;
  final VoidCallback onChangePhoto;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0876E7), Color(0xFF3F7CFF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, isEditing ? 14 : 22, 24, 28),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isEditing)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ),
                const Text(
                  'Profil Saya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onNotificationTap,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 19,
                          ),
                          Positioned(
                            right: 10,
                            top: 9,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isEditing ? 10 : 18),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: isEditing ? 104 : 118,
                height: isEditing ? 104 : 118,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6A7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: avatar,
              ),
              if (isEditing)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: GestureDetector(
                    onTap: onChangePhoto,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            name.isEmpty ? 'Pengguna' : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: isEditing ? 18 : 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            email.isEmpty ? '-' : email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    this.titleColor = AppColors.bodyText,
    this.backgroundColor = AppColors.surface,
    this.showChevron = true,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (showChevron)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.border,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.prefixText,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.bodyText,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.mutedText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: AppColors.mutedText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
      ),
      validator: validator,
    );
  }
}

class _HelpCenterPage extends StatelessWidget {
  const _HelpCenterPage();

  static const _faqItems = [
    'Bagaimana cara membatalkan pesanan?',
    'Metode pembayaran apa saja yang tersedia?',
    'Bisakah saya merubah tanggal menginap?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.bodyText,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 36,
                          height: 36,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Pusat Bantuan',
                        style: TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const _HelpSearchField(),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Sering Ditanyakan',
                          style: TextStyle(
                            color: AppColors.bodyText,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: const Size(0, 34),
                        ),
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._faqItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FaqTile(title: item),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _NeedHelpCard(),
                ],
              ),
            ),
            const _HelpBottomNav(),
          ],
        ),
      ),
    );
  }
}

class _HelpSearchField extends StatelessWidget {
  const _HelpSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.mutedText, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cari pertanyaan atau bantuan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.mutedText, size: 21),
        ],
      ),
    );
  }
}

class _NeedHelpCard extends StatelessWidget {
  const _NeedHelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Masih butuh bantuan?',
            style: TextStyle(
              color: AppColors.bodyText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tim dukungan kami siap membantumu 24/7 melalui layanan live chat atau email.',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline, size: 19),
              label: const Text(
                'Hubungi Live Chat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.bodyText,
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.mail_outline, size: 19),
              label: const Text(
                'Kirim Email',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpBottomNav extends StatelessWidget {
  const _HelpBottomNav();

  static const _items = [
    (Icons.home_filled, 'Beranda'),
    (Icons.explore_outlined, 'Pencarian'),
    (Icons.receipt_long_outlined, 'Pesanan'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final item in _items)
                SizedBox(
                  width: 44,
                  height: 40,
                  child: Icon(item.$1, color: AppColors.mutedText, size: 20),
                ),
              Container(
                width: 102,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline, color: Colors.white, size: 17),
                    SizedBox(width: 7),
                    Text(
                      'Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
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
