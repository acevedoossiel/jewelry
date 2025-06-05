import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserSession().then((_) {
      if (authProvider.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });

                  final success = await authProvider.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() {
                      errorMessage = 'Credenciales inválidas';
                    });
                  }
                },
                child: const Text('Ingresar'),
              ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
