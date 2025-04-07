import 'package:flutter/material.dart';
import 'pagina_suscripciones.dart';

void main() => runApp(SuscripcionesApp());

class SuscripcionesApp extends StatelessWidget {
  const SuscripcionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Suscripciones',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: PaginaSuscripciones(),
    );
  }
}
