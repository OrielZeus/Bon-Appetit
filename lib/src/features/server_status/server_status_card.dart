import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:flutter/material.dart';

class ServerStatusCard extends StatelessWidget {
  const ServerStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.dns_outlined, color: colors.secondary),
            SizedBox(
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Baker server',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConfig.apiBaseUrl,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SpacerStatus(),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.sync_outlined),
              label: const Text('Ready'),
            ),
          ],
        ),
      ),
    );
  }
}

class SpacerStatus extends StatelessWidget {
  const SpacerStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 8);
  }
}
