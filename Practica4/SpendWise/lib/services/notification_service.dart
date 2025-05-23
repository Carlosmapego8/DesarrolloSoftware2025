import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _enabled = true;

  void enable(bool isEnabled) {
    _enabled = isEnabled;
  }

  bool get isEnabled => _enabled;

  void notify(BuildContext context, String message, {Color? backgroundColor}) {
    if (!_enabled) {
      debugPrint("🔕 Notificación ignorada (desactivada): $message");
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
