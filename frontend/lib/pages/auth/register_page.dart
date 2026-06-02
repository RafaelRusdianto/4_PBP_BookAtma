import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';

import '../../services/auth_service.dart';

import '../../widgets/auth_scaffold.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final result = await AuthService().register(
      nama: _namaController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      noHp: _noHpController.text.trim(),
    );

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));

      Navigator.of(context).pushReplacementNamed(AppRoutes.settings);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackCircleButton(),

            const SizedBox(height: 28),

            const Text(
              'Buat Akun Baru',
              style: TextStyle(
                color: AppColors.bodyText,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 30),

            AuthTextField(
              label: 'Nama',
              hint: 'Masukkan nama',
              controller: _namaController,
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            AuthTextField(
              label: 'No HP',
              hint: '08xxxxxxxxxx',
              controller: _noHpController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'No HP wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            AuthTextField(
              label: 'Email',
              hint: 'nama@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),

            const SizedBox(height: 16),

            AuthTextField(
              label: 'Password',
              hint: 'Masukkan password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: validateRequiredPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            AuthTextField(
              label: 'Konfirmasi Password',
              hint: 'Ulangi password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Password tidak sama';
                }

                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),

            const SizedBox(height: 22),

            PrimaryButton(label: 'Buat Akun', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
