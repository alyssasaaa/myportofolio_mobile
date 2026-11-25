import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/experience_form.dart';
import '../screens/login_screen.dart';
import '../services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  return await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ) ??
      false;
}

Future<void> openExperienceForm(BuildContext context) async {
  if (await ensureLoggedIn(context) && context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await context.read<AuthState>().logout();
    messenger.showSnackBar(const SnackBar(content: Text('Logged out.')));
  } catch (_) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Signed out locally. Server logout could not be confirmed.',
        ),
      ),
    );
  }
}
