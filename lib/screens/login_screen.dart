import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final u = TextEditingController(text: 'kminchelle');
  final p = TextEditingController(text: '0lelplR');

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StoreProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('ورود / ثبت‌نام')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: u, decoration: const InputDecoration(labelText: 'نام کاربری')),
            const SizedBox(height: 12),
            TextField(controller: p, obscureText: true, decoration: const InputDecoration(labelText: 'رمز عبور')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: prov.loading
                    ? null
                    : () async {
                  try {
                    await prov.login(u.text, p.text);
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                  }
                },
                child: prov.loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('ورود'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}