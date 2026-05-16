import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:bon_appetit/src/core/theme/app_theme.dart';
import 'package:bon_appetit/src/features/auth/login_screen.dart';
import 'package:bon_appetit/src/features/shell/bon_appetit_shell.dart';
import 'package:flutter/material.dart';

class BonAppetitApp extends StatefulWidget {
  const BonAppetitApp({super.key});

  @override
  State<BonAppetitApp> createState() => _BonAppetitAppState();
}

class _BonAppetitAppState extends State<BonAppetitApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        final strings = AppStrings(_appState.language);
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: _appState.isSignedIn
              ? BonAppetitShell(appState: _appState, strings: strings)
              : LoginScreen(appState: _appState, strings: strings),
        );
      },
    );
  }
}
