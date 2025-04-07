import 'package:flutter/material.dart';
import 'screens/suscripciones_page.dart';

void main() => runApp(SuscripcionesApp());

class SuscripcionesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Suscripciones',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: SuscripcionesPage(),
    );
  }
}
