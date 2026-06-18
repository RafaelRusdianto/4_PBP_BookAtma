import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/api_config.dart';
import '../core/theme/app_colors.dart';
import '../services/auth_service.dart';

class GoogleButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final void Function(String message)? onError;
  final String label;

  const GoogleButton({
    super.key,
    this.onSuccess,
    this.onError,
    this.label = 'Masuk dengan Google',
  });

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: ApiConfig.googleServerClientId,
  );

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        widget.onError?.call('Gagal mendapatkan token autentikasi Google');
        setState(() => _isLoading = false);
        return;
      }

      final result = await AuthService().googleLogin(
        email: account.email,
        nama: account.displayName ?? account.email.split('@').first,
        idToken: idToken,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        widget.onSuccess?.call();
      } else {
        widget.onError?.call(
          result['message']?.toString() ?? 'Login Google gagal',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      widget.onError?.call(
        'Gagal terhubung ke Google: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: AppColors.bodyText,
          disabledBackgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
        label: Text(
          _isLoading ? 'Memproses...' : widget.label,
          style: const TextStyle(
            color: AppColors.bodyText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
