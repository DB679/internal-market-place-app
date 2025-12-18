import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'sell_listing_page.dart';
import 'my_listings_page.dart';
import 'account_page.dart';
import 'admin_dashboard_page.dart'; // NEW

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.isAdmin,
    this.initialIndex = 0,
  });

  /// Whether logged-in user is admin
  final bool isAdmin;

  /// Which tab to open first
  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _pages = [
      const HomeScreen(),        // 0
      const WishlistScreen(),    // 1
      const SellListingPage(),   // 2

      // 👇 Admin-only page
      if (widget.isAdmin) const AdminDashboardPage(),

      const MyListingsPage(),    // last-2
      const AccountPage(),       // last-1
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Sell',
          ),

          // 👇 Admin tab appears ONLY for admins
          if (widget.isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list),
            label: 'My Listings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
