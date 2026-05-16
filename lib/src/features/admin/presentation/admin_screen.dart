import 'package:bon_appetit/src/core/localization/app_language.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key, required this.appState, required this.strings});

  final AppState appState;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(strings.t('settings'),
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        _ProductSettings(appState: appState),
        const SizedBox(height: 12),
        _UserSettings(appState: appState, strings: strings),
      ],
    );
  }
}

class _ProductSettings extends StatelessWidget {
  const _ProductSettings({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menú configurable',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...appState.products.map(
              (product) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.asset(product.assetPath, width: 48),
                title: Text(product.name),
                subtitle: Text(
                  '\$${product.price.toStringAsFixed(2)} | ${product.preparationMinutes}m',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editProduct(context, product),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(BuildContext context, MenuProduct product) {
    final price = TextEditingController(text: product.price.toStringAsFixed(2));
    final minutes =
        TextEditingController(text: product.preparationMinutes.toString());
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: minutes,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Minutos'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              appState.updateProduct(
                product,
                double.tryParse(price.text) ?? product.price,
                int.tryParse(minutes.text) ?? product.preparationMinutes,
              );
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _UserSettings extends StatelessWidget {
  const _UserSettings({required this.appState, required this.strings});

  final AppState appState;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.t('users'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...appState.users.map(
              (user) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: Text(user.name),
                subtitle: Text(
                  '${user.email} | ${user.branch} | ${user.groups.join(', ')}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.manage_accounts_outlined),
                  onPressed: () => _editUser(context, user),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editUser(BuildContext context, AppUser user) {
    var language = user.language;
    var branch = user.branch;
    final selectedGroups = {...user.groups};
    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(user.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<AppLanguage>(
                  value: language,
                  decoration: InputDecoration(labelText: strings.t('language')),
                  items: AppLanguage.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => language = value);
                  },
                ),
                DropdownButtonFormField<String>(
                  value: branch,
                  decoration: const InputDecoration(labelText: 'Sucursal'),
                  items: appState.branches
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => branch = value);
                  },
                ),
                const SizedBox(height: 8),
                ...appState.groups.map(
                  (group) => CheckboxListTile(
                    value: selectedGroups.contains(group),
                    onChanged: (value) {
                      setDialogState(() {
                        if (value ?? false) {
                          selectedGroups.add(group);
                        } else {
                          selectedGroups.remove(group);
                        }
                      });
                    },
                    title: Text(group),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                appState.updateUser(
                  user,
                  language,
                  branch,
                  selectedGroups.toList(),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
