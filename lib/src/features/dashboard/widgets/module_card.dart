import 'package:bon_appetit/src/features/dashboard/models/feature_module.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module});

  final FeatureModule module;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(module.icon, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    module.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                module.description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              module.status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
