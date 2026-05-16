import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/core/theme/app_theme.dart';
import 'package:bon_appetit/src/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class BonAppetitApp extends StatelessWidget {
  const BonAppetitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const DashboardScreen(),
    );
  }
}
