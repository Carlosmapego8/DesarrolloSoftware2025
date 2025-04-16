import 'package:flutter/material.dart';
import '../filters/email_filter.dart';
import '../filters/password_filter.dart';
import '../filters/email_exists_filter.dart';
import '../managers/filter_manager.dart';
import '../services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  final FilterManager filterManager = FilterManager();
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    filterManager.addFilter(EmailFilter());
    filterManager.addFilter(EmailExistsFilter());
    filterManager.addFilter(PasswordFilter());
  }

  void sendNotificaiton(String? message) {
    if (message != null) {
      NotificationService.showCustomSnackbar(
          message: message, backgroundColor: Colors.red);
    }
      else {
      NotificationService.showCustomSnackbar(
          message: '¡Autenticación exitosa!', duration: const Duration(seconds: 3), backgroundColor: Colors.green);
    }
  }

  void authenticate() {
    final email = emailController.text;
    final password = passwordController.text;
    final validationError = filterManager.validate(email, password);


    sendNotificaiton(validationError);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authenticate,
              child: const Text('Ingresar'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: errorMessage == '¡Autenticación exitosa!'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
