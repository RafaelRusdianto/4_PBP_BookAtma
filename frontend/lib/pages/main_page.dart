import 'package:flutter/material.dart';

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

  final GlobalKey<SearchPageState> _searchPageKey =
      GlobalKey<SearchPageState>();

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}