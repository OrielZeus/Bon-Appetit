import 'package:bon_appetit/src/core/localization/app_language.dart';

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  static const _values = {
    'signIn': {
      AppLanguage.es: 'Iniciar sesión',
      AppLanguage.en: 'Sign in',
      AppLanguage.fr: 'Connexion',
    },
    'enterWorkspace': {
      AppLanguage.es: 'Entrar al espacio',
      AppLanguage.en: 'Enter workspace',
      AppLanguage.fr: 'Entrer',
    },
    'home': {
      AppLanguage.es: 'Inicio',
      AppLanguage.en: 'Home',
      AppLanguage.fr: 'Accueil',
    },
    'menu': {
      AppLanguage.es: 'Menú',
      AppLanguage.en: 'Menu',
      AppLanguage.fr: 'Menu',
    },
    'orders': {
      AppLanguage.es: 'Pedidos',
      AppLanguage.en: 'Orders',
      AppLanguage.fr: 'Commandes',
    },
    'track': {
      AppLanguage.es: 'Ruta',
      AppLanguage.en: 'Track',
      AppLanguage.fr: 'Suivi',
    },
    'users': {
      AppLanguage.es: 'Usuarios',
      AppLanguage.en: 'Users',
      AppLanguage.fr: 'Utilisateurs',
    },
    'settings': {
      AppLanguage.es: 'Configuración',
      AppLanguage.en: 'Settings',
      AppLanguage.fr: 'Paramètres',
    },
    'notifications': {
      AppLanguage.es: 'Notificaciones',
      AppLanguage.en: 'Notifications',
      AppLanguage.fr: 'Notifications',
    },
    'addToCart': {
      AppLanguage.es: 'Agregar',
      AppLanguage.en: 'Add',
      AppLanguage.fr: 'Ajouter',
    },
    'cart': {
      AppLanguage.es: 'Carrito',
      AppLanguage.en: 'Cart',
      AppLanguage.fr: 'Panier',
    },
    'schedule': {
      AppLanguage.es: 'Agendar',
      AppLanguage.en: 'Schedule',
      AppLanguage.fr: 'Planifier',
    },
    'createOrder': {
      AppLanguage.es: 'Crear pedido',
      AppLanguage.en: 'Create order',
      AppLanguage.fr: 'Créer commande',
    },
    'language': {
      AppLanguage.es: 'Idioma',
      AppLanguage.en: 'Language',
      AppLanguage.fr: 'Langue',
    },
    'role': {
      AppLanguage.es: 'Rol',
      AppLanguage.en: 'Role',
      AppLanguage.fr: 'Rôle',
    },
  };

  String t(String key) =>
      _values[key]?[language] ?? _values[key]?[AppLanguage.es] ?? key;
}
