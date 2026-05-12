import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';

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

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.settings);
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
            ),

            const SizedBox(height: 22),

            PrimaryButton(label: 'Buat Akun', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
