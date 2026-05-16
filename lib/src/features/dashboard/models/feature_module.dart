import 'package:flutter/material.dart';

class FeatureModule {
  const FeatureModule({
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
  });

  final String title;
  final String description;
  final IconData icon;
  final String status;
}
