String? validateEmail(String? value) {
  final email = value?.trim() ?? '';

  if (email.isEmpty) {
    return 'Email wajib diisi';
  }

  final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$');

  if (!emailRegex.hasMatch(email)) {
    return 'Email tidak valid';
  }

  return null;
}

String? validateRequiredPassword(String? value) {
  if ((value ?? '').isEmpty) {
    return 'Password wajib diisi';
  }

  return null;
}
