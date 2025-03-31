import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interception Filters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

abstract class Filter {
  String? execute(String value);
}

class EmailFilter extends Filter {
  @override
  String? execute(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
    if (!emailRegex.hasMatch(email)) {
      return 'Correo inválido';
    }
    return null;
  }
}

class PasswordFilter extends Filter {
  @override
  String? execute(String password) {
    if (password.length < 8) return 'Contraseña demasiado corta';
    if (!password.contains(RegExp(r'[A-Z]')))
      return 'Debe contener una mayúscula';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Debe contener un número';
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')))
      return 'Debe contener un carácter especial';
    if (RegExp(r'(.)\1{2,}').hasMatch(password))
      return 'No debe tener caracteres repetidos consecutivamente';
    return null;
  }
}

class FilterManager {
  final List<Filter> filters = [];

  void addFilter(Filter filter) {
    filters.add(filter);
  }

  String? executeFilters(String email, String password) {
    for (var filter in filters) {
      if (filter is EmailFilter) {
        final result = filter.execute(email);
        if (result != null) return result;
      } else if (filter is PasswordFilter) {
        final result = filter.execute(password);
        if (result != null) return result;
      }
    }
    return null;
  }
}

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

  @override
  void initState() {
    super.initState();
    filterManager.addFilter(EmailFilter());
    filterManager.addFilter(PasswordFilter());
  }

  void authenticate() {
    final email = emailController.text;
    final password = passwordController.text;
    final validationError = filterManager.executeFilters(email, password);

    if (validationError != null) {
      setState(() => errorMessage = validationError);
      return;
    }

    setState(() => errorMessage = '¡Autenticación exitosa!');
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
