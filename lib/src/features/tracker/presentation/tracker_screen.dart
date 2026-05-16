import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:flutter/material.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key, required this.strings});

  final AppStrings strings;

  static const _steps = [
    ('Order received', 'Baker API accepted the order draft.', true),
    ('Kitchen preparing', 'Restaurant confirms production status.', true),
    ('Courier assigned', 'Delivery actor and route are selected.', false),
    ('Delivered', 'Customer receives the order.', false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(strings.t('track'),
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 8,
                child: Image.asset(AppAssets.courier, fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _steps.map((step) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: step.$3,
                      onChanged: null,
                      title: Text(step.$1),
                      subtitle: Text(step.$2),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
