import 'package:flutter/material.dart';

class NotificationService {
  // Creamos una key que referenciará al ScaffoldMessenger de nuestra app.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();

  // Método estático para mostrar un snackbar con un mensaje de texto.
  static void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));

    // currentState nos da acceso al ScaffoldMessenger
    messengerKey.currentState?.showSnackBar(snackBar);
  }

  // Método estático para mostrar un snackbar con más personalización.
  static void showCustomSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
