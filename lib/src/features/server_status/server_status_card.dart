import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/features/server_status/data/server_status_repository.dart';
import 'package:flutter/material.dart';

class ServerStatusCard extends StatefulWidget {
  const ServerStatusCard({super.key});

  @override
  State<ServerStatusCard> createState() => _ServerStatusCardState();
}

class _ServerStatusCardState extends State<ServerStatusCard> {
  final _repository = ServerStatusRepository();
  late Future<ServerStatus> _futureStatus;

  @override
  void initState() {
    super.initState();
    _futureStatus = _repository.fetchStatus();
  }

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
            FutureBuilder<ServerStatus>(
              future: _futureStatus,
              builder: (context, snapshot) {
                final isReady = snapshot.data?.status == 'ok';
                final label = snapshot.connectionState == ConnectionState.done
                    ? isReady
                        ? 'Ready'
                        : 'Offline'
                    : 'Checking';

                return FilledButton.tonalIcon(
                  onPressed: () {
                    setState(() {
                      _futureStatus = _repository.fetchStatus();
                    });
                  },
                  icon: Icon(
                    isReady ? Icons.check_circle_outline : Icons.sync_outlined,
                  ),
                  label: Text(label),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
