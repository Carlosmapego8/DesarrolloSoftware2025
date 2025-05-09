import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import '../services/notification_service.dart';

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
      scaffoldMessengerKey: NotificationService.messengerKey,
      home: const LoginScreen(),
    );
  }
}
