import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/search_filter_model.dart';
import '../widgets/bottom_navbar.dart';
import 'home/home_page.dart';
import 'orders/order_page.dart';
import 'profile/profile_page.dart';
import 'search/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;

  final GlobalKey<SearchPageState> _searchPageKey =
      GlobalKey<SearchPageState>();

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleBack() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tekan back sekali lagi untuk keluar'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    SystemNavigator.pop();
  }

  void _onSearchFromHome(SearchFilterModel filter) {
    setState(() {
      _selectedIndex = 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _searchPageKey.currentState?.searchFromExternalFilter(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onSearchSubmitted: _onSearchFromHome),
      SearchPage(key: _searchPageKey),
      const OrderPage(),
      const ProfilePage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: BottomNavbar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
