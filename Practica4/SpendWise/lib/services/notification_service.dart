import 'package:flutter/material.dart';

/// Servicio singleton para mostrar notificaciones visuales (SnackBars).
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Controla si las notificaciones están habilitadas o no.
  bool _enabled = true;

  /// Habilita o deshabilita las notificaciones.
  void enable(bool isEnabled) {
    _enabled = isEnabled;
  }

  /// Indica si las notificaciones están habilitadas.
  bool get isEnabled => _enabled;

  /// Muestra una notificación SnackBar en el [context] dado con el [message] especificado.
  /// Puede incluir un [backgroundColor] opcional.
  void notify(BuildContext context, String message, {Color? backgroundColor}) {
    if (!_enabled) {
      debugPrint("Notificación ignorada (desactivada): $message");
      return;
    }

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

