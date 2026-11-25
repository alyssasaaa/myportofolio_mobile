import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  String username = '', password = '';
  bool busy = false;

  Future<void> submit() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await context.read<AuthState>().login(username.trim(), password);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is ApiException
                  ? error.toString()
                  : 'Cannot reach the server.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (value) => username = value,
            validator: (value) =>
                value!.trim().isEmpty ? 'Enter your username.' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: (value) =>
                value!.isEmpty ? 'Enter your password.' : null,
            onFieldSubmitted: (_) => submit(),
          ),
          ElevatedButton(
            onPressed: busy ? null : submit,
            child: Text(busy ? 'Logging in…' : 'Login'),
          ),
        ],
      ),
    ),
  );
}
