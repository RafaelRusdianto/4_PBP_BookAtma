import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';

import '../../widgets/auth_scaffold.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/divider_with_text.dart';
import '../../widgets/google_button.dart';
import '../../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await AuthService().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result['success'] == true) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Email atau password salah',
          ),
        ),
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
              'Selamat Datang Kembali',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Silakan masuk ke akun Anda.',
              style: TextStyle(color: AppColors.mutedText, fontSize: 13),
            ),

            const SizedBox(height: 32),

            AuthTextField(
              label: 'Email',
              hint: 'user@mail.com',
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

            const SizedBox(height: 22),

            PrimaryButton(
              label: _isSubmitting ? 'Memproses...' : 'Masuk',
              onPressed: _isSubmitting ? null : _submit,
            ),

            const SizedBox(height: 24),

            const DividerWithText(text: 'atau'),

            const SizedBox(height: 20),

            const GoogleButton(),
          ],
        ),
      ),
    );
  }
}
