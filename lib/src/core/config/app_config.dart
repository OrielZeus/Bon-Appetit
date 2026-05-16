class AppConfig {
  const AppConfig._();

  static const appName = 'Bon Appetit';

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const sourceProjects = <String>[
    'food_delivery_meal',
    'food_delivery_app',
    'new_food_delivery_project',
  ];
}
