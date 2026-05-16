import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/core/localization/app_language.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:bon_appetit/src/features/admin/presentation/admin_screen.dart';
import 'package:bon_appetit/src/features/cart/presentation/cart_screen.dart';
import 'package:bon_appetit/src/features/dashboard/dashboard_screen.dart';
import 'package:bon_appetit/src/features/notifications/presentation/notifications_screen.dart';
import 'package:bon_appetit/src/features/orders/presentation/orders_screen.dart';
import 'package:bon_appetit/src/features/restaurants/presentation/restaurants_screen.dart';
import 'package:bon_appetit/src/features/tracker/presentation/tracker_screen.dart';
import 'package:flutter/material.dart';

class BonAppetitShell extends StatefulWidget {
  const BonAppetitShell({
    super.key,
    required this.appState,
    required this.strings,
  });

  final AppState appState;
  final AppStrings strings;

  @override
  State<BonAppetitShell> createState() => _BonAppetitShellState();
}

class _BonAppetitShellState extends State<BonAppetitShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations();
    if (_selectedIndex >= destinations.length) {
      _selectedIndex = 0;
    }

    final screens =
        destinations.map((destination) => destination.screen).toList();
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? null
            : IconButton(
                tooltip: 'Back',
                onPressed: () => setState(() => _selectedIndex = 0),
                icon: const Icon(Icons.arrow_back_outlined),
              ),
        title: const Text(AppConfig.appName),
        actions: [
          DropdownButton<AppLanguage>(
            value: widget.appState.language,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value != null) widget.appState.setLanguage(value);
            },
            items: AppLanguage.values
                .map(
                  (language) => DropdownMenuItem(
                    value: language,
                    child: Text(language.code.toUpperCase()),
                  ),
                )
                .toList(),
          ),
          IconButton(
            tooltip: widget.strings.t('notifications'),
            onPressed: () => _openByKey('notifications'),
            icon: Badge(
              label: Text(widget.appState.notifications.length.toString()),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            tooltip: widget.strings.t('cart'),
            onPressed: () => _openByKey('cart'),
            icon: Badge(
              label: Text(widget.appState.cart.length.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text(widget.appState.selectedUser.name)),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.appState.signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _selectIndex,
                labelType: NavigationRailLabelType.all,
                destinations: destinations
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
              ),
            Expanded(child: screens[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectIndex,
              destinations: destinations
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }

  List<_Destination> _destinations() {
    final strings = widget.strings;
    final appState = widget.appState;
    final role = appState.selectedUser.role;
    final items = [
      _Destination(
        key: 'home',
        label: strings.t('home'),
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        screen: DashboardScreen(
            appState: appState, strings: strings, onOpenSection: _selectIndex),
      ),
      _Destination(
        key: 'menu',
        label: strings.t('menu'),
        icon: Icons.restaurant_menu_outlined,
        selectedIcon: Icons.restaurant_menu,
        screen: RestaurantsScreen(appState: appState, strings: strings),
      ),
      _Destination(
        key: 'orders',
        label: strings.t('orders'),
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        screen: OrdersScreen(appState: appState, strings: strings),
      ),
      _Destination(
        key: 'track',
        label: strings.t('track'),
        icon: Icons.delivery_dining_outlined,
        selectedIcon: Icons.delivery_dining,
        screen: TrackerScreen(strings: strings),
      ),
      _Destination(
        key: 'cart',
        label: strings.t('cart'),
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart,
        screen: CartScreen(appState: appState, strings: strings),
      ),
      _Destination(
        key: 'notifications',
        label: strings.t('notifications'),
        icon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications,
        screen: NotificationsScreen(appState: appState, strings: strings),
      ),
    ];

    if (role == UserRole.staff || role == UserRole.admin) {
      items.add(
        _Destination(
          key: 'settings',
          label: strings.t('settings'),
          icon: Icons.tune_outlined,
          selectedIcon: Icons.tune,
          screen: AdminScreen(appState: appState, strings: strings),
        ),
      );
    }

    return items;
  }

  void _openByKey(String key) {
    final index = _destinations().indexWhere((item) => item.key == key);
    if (index >= 0) _selectIndex(index);
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _Destination {
  const _Destination({
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.screen,
  });

  final String key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget screen;
}
