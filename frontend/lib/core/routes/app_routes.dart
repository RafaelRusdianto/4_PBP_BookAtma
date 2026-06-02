import 'package:flutter/material.dart';

import '../../pages/auth/experience_settings_page.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/landing/landing_page.dart';
import '../../pages/loading/loading_screen.dart';

class AppRoutes {
  static const loading = '/';
  static const landing = '/landing';
  static const login = '/login';
  static const register = '/register';
  static const settings = '/settings';
  static const home = '/home';

  static Map<String, WidgetBuilder> routes = {
    loading: (_) => const LoadingScreen(),
    landing: (_) => const LandingPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    settings: (_) => const ExperienceSettingsPage(),
    home: (_) => const HomePage(),
  };
}
