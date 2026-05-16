import 'package:bon_appetit/src/core/config/app_config.dart';
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
  bool _isSignedIn = false;
  String _displayName = 'Internal QA';

  void _handleSignIn(String displayName) {
    setState(() {
      _displayName = displayName.trim().isEmpty ? 'Internal QA' : displayName;
      _isSignedIn = true;
    });
  }

  void _handleSignOut() {
    setState(() {
      _isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _isSignedIn
          ? BonAppetitShell(
              displayName: _displayName,
              onSignOut: _handleSignOut,
            )
          : LoginScreen(onSignIn: _handleSignIn),
    );
  }
}
