import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/localization/app_language.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.appState, required this.strings});

  final AppState appState;
  final AppStrings strings;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'cliente@gmail.123');
  final _passwordController = TextEditingController(text: 'password123');
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _LoginHero(colors: colors),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.strings.t('signIn'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    DropdownButton<AppLanguage>(
                      value: widget.appState.language,
                      onChanged: (value) {
                        if (value != null) widget.appState.setLanguage(value);
                      },
                      items: AppLanguage.values
                          .map(
                            (language) => DropdownMenuItem(
                              value: language,
                              child: Text(language.label),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.appState.users.map((user) {
                    return ActionChip(
                      avatar: Icon(_roleIcon(user.role), size: 18),
                      label: Text(user.email),
                      onPressed: () {
                        _emailController.text = user.email;
                        _passwordController.text = user.password;
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: TextStyle(color: colors.error)),
                ],
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _signIn,
                  icon: const Icon(Icons.login_outlined),
                  label: Text(widget.strings.t('enterWorkspace')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() {
    final ok = widget.appState.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!ok) {
      setState(() {
        _error = 'Credenciales inválidas / Invalid credentials';
      });
    }
  }

  IconData _roleIcon(UserRole role) {
    return switch (role) {
      UserRole.customer => Icons.person_outline,
      UserRole.staff => Icons.storefront_outlined,
      UserRole.admin => Icons.admin_panel_settings_outlined,
    };
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.restaurantOne, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppAssets.logo, height: 46),
                  const SizedBox(height: 12),
                  Text(
                    'Bon Appetit',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    'Pedidos, staff, pagos, sucursales y tracking.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
