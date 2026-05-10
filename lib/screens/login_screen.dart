import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import '../widgets/uawc_logo_header.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final api = ApiService();
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);
    try {
      final result = await api.login(username.text.trim(), password.text);
      final token = result['token']?.toString() ?? result['access_token']?.toString() ?? result['data']?['token']?.toString();
      if (token != null) {
        await SessionService().saveToken(token);
        api.token = token;
      }
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(api: api)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تسجيل الدخول: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تسجيل الدخول')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const UawcLogoHeader(),
            const SizedBox(height: 26),
            TextField(controller: username, decoration: const InputDecoration(labelText: 'اسم المستخدم')),
            const SizedBox(height: 12),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}
