import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  static const appName = 'Bon Appetit';

  static String get apiBaseUrl {
    const configured = String.fromEnvironment('API_BASE_URL');
    if (configured.isNotEmpty) return configured;
    return kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
  }

  static const apiTimeout = Duration(seconds: 8);

  static const sourceProjects = <String>[
    'food_delivery_meal',
    'food_delivery_app',
    'new_food_delivery_project',
  ];
}
