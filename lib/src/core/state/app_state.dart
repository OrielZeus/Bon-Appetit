import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/localization/app_language.dart';
import 'package:flutter/foundation.dart';

enum UserRole { customer, staff, admin }

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.language,
    required this.groups,
    required this.branch,
  });

  final String name;
  final String email;
  final String password;
  final UserRole role;
  final AppLanguage language;
  final List<String> groups;
  final String branch;

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
    AppLanguage? language,
    List<String>? groups,
    String? branch,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      language: language ?? this.language,
      groups: groups ?? this.groups,
      branch: branch ?? this.branch,
    );
  }
}

class MenuProduct {
  const MenuProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.preparationMinutes,
    required this.assetPath,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final int preparationMinutes;
  final String assetPath;

  MenuProduct copyWith({double? price, int? preparationMinutes}) {
    return MenuProduct(
      id: id,
      name: name,
      category: category,
      price: price ?? this.price,
      preparationMinutes: preparationMinutes ?? this.preparationMinutes,
      assetPath: assetPath,
    );
  }
}

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final MenuProduct product;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

class LocalOrder {
  const LocalOrder({
    required this.code,
    required this.customer,
    required this.items,
    required this.scheduledAt,
    required this.status,
    required this.paymentStatus,
    required this.total,
  });

  final String code;
  final String customer;
  final List<CartItem> items;
  final DateTime scheduledAt;
  final String status;
  final String paymentStatus;
  final double total;

  LocalOrder copyWith({
    DateTime? scheduledAt,
    String? status,
    String? paymentStatus,
  }) {
    return LocalOrder(
      code: code,
      customer: customer,
      items: items,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      total: total,
    );
  }
}

class AppNotification {
  const AppNotification({
    required this.titleKey,
    required this.message,
    required this.createdAt,
  });

  final String titleKey;
  final String message;
  final DateTime createdAt;
}

class AppState extends ChangeNotifier {
  AppState() {
    _selectedUser = users.first;
    _language = _selectedUser.language;
  }

  final List<AppUser> users = [
    const AppUser(
      name: 'Cliente Demo',
      email: 'cliente@gmail.123',
      password: 'password123',
      role: UserRole.customer,
      language: AppLanguage.es,
      groups: ['Clientes'],
      branch: 'Sucursal Central',
    ),
    const AppUser(
      name: 'Staff Demo',
      email: 'staff@gmail.123',
      password: 'password123',
      role: UserRole.staff,
      language: AppLanguage.en,
      groups: ['Operaciones', 'Caja'],
      branch: 'Sucursal Central',
    ),
    const AppUser(
      name: 'Admin Demo',
      email: 'admin@gmail.123',
      password: 'password123',
      role: UserRole.admin,
      language: AppLanguage.fr,
      groups: ['Administradores'],
      branch: 'Todas',
    ),
  ];

  final List<String> branches = ['Sucursal Central', 'Bakery Norte', 'Todas'];
  final List<String> groups = [
    'Clientes',
    'Operaciones',
    'Caja',
    'Administradores'
  ];

  final List<MenuProduct> products = [
    const MenuProduct(
      id: 'pizza',
      name: 'Stone Oven Pizza',
      category: 'Restaurant',
      price: 12.90,
      preparationMinutes: 120,
      assetPath: AppAssets.pizza,
    ),
    const MenuProduct(
      id: 'burger',
      name: 'Beef Burger',
      category: 'Delivery',
      price: 9.50,
      preparationMinutes: 35,
      assetPath: AppAssets.burger,
    ),
    const MenuProduct(
      id: 'cupcake',
      name: 'Cup Cake Box',
      category: 'Bakery',
      price: 7.20,
      preparationMinutes: 60,
      assetPath: AppAssets.cupcake,
    ),
  ];

  final List<CartItem> cart = [];
  final List<LocalOrder> localOrders = [];
  final List<AppNotification> notifications = [];

  late AppUser _selectedUser;
  late AppLanguage _language;

  AppUser get selectedUser => _selectedUser;
  AppLanguage get language => _language;
  bool get isSignedIn => _isSignedIn;
  bool _isSignedIn = false;

  double get cartTotal =>
      cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void setLanguage(AppLanguage language) {
    _language = language;
    _selectedUser = _selectedUser.copyWith(language: language);
    notifyListeners();
  }

  bool signIn(String email, String password) {
    final match =
        users.where((user) => user.email == email && user.password == password);
    if (match.isEmpty) return false;
    _selectedUser = match.first;
    _language = _selectedUser.language;
    _isSignedIn = true;
    _notify('notifications', 'Sesión iniciada: ${_selectedUser.name}');
    notifyListeners();
    return true;
  }

  void signOut() {
    _isSignedIn = false;
    notifyListeners();
  }

  void addToCart(MenuProduct product) {
    final index = cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cart[index] = cart[index].copyWith(quantity: cart[index].quantity + 1);
    } else {
      cart.add(CartItem(product: product, quantity: 1));
    }
    _notify('cart', '${product.name} agregado al carrito');
    notifyListeners();
  }

  void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void createOrder(DateTime scheduledAt) {
    if (cart.isEmpty) return;
    final order = LocalOrder(
      code: 'BA-${(localOrders.length + 3).toString().padLeft(4, '0')}',
      customer: selectedUser.name,
      items: List.unmodifiable(cart),
      scheduledAt: scheduledAt,
      status: 'Scheduled',
      paymentStatus: 'Pending',
      total: cartTotal,
    );
    localOrders.insert(0, order);
    cart.clear();
    _notify('orders', 'Pedido ${order.code} creado');
    notifyListeners();
  }

  void updateOrder(LocalOrder order, {String? status, String? paymentStatus}) {
    final index = localOrders.indexWhere((item) => item.code == order.code);
    if (index < 0) return;
    localOrders[index] = order.copyWith(
      status: status,
      paymentStatus: paymentStatus,
    );
    _notify('orders', 'Pedido ${order.code} actualizado');
    notifyListeners();
  }

  void updateProduct(MenuProduct product, double price, int minutes) {
    final index = products.indexWhere((item) => item.id == product.id);
    if (index < 0) return;
    products[index] =
        product.copyWith(price: price, preparationMinutes: minutes);
    _notify('settings', '${product.name} actualizado');
    notifyListeners();
  }

  void updateUser(
      AppUser user, AppLanguage language, String branch, List<String> groups) {
    final index = users.indexWhere((item) => item.email == user.email);
    if (index < 0) return;
    users[index] =
        user.copyWith(language: language, branch: branch, groups: groups);
    if (_selectedUser.email == user.email) {
      _selectedUser = users[index];
      _language = language;
    }
    _notify('users', '${user.name} actualizado');
    notifyListeners();
  }

  void _notify(String titleKey, String message) {
    notifications.insert(
      0,
      AppNotification(
        titleKey: titleKey,
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }
}
