import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
    required this.appState,
    required this.strings,
  });

  final AppState appState;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          strings.t('notifications'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (appState.notifications.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Sin notificaciones.'),
            ),
          )
        else
          ...appState.notifications.map(
            (notification) => Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(strings.t(notification.titleKey)),
                subtitle: Text(notification.message),
              ),
            ),
          ),
      ],
    );
  }
}
