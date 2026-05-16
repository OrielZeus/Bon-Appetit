import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/features/dashboard/dashboard_screen.dart';
import 'package:bon_appetit/src/features/orders/presentation/orders_screen.dart';
import 'package:bon_appetit/src/features/restaurants/presentation/restaurants_screen.dart';
import 'package:bon_appetit/src/features/tracker/presentation/tracker_screen.dart';
import 'package:flutter/material.dart';

class BonAppetitShell extends StatefulWidget {
  const BonAppetitShell({
    super.key,
    required this.displayName,
    required this.onSignOut,
  });

  final String displayName;
  final VoidCallback onSignOut;

  @override
  State<BonAppetitShell> createState() => _BonAppetitShellState();
}

class _BonAppetitShellState extends State<BonAppetitShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onOpenSection: _selectIndex),
      const RestaurantsScreen(),
      const OrdersScreen(),
      const TrackerScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text(widget.displayName)),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.delivery_dining_outlined),
            selectedIcon: Icon(Icons.delivery_dining),
            label: 'Track',
          ),
        ],
      ),
    );
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
