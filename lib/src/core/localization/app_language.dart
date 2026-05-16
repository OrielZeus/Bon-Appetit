enum AppLanguage {
  es('es', 'Español'),
  en('en', 'English'),
  fr('fr', 'Français');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;
}
