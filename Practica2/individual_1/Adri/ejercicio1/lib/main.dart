import 'package:flutter/material.dart';
import 'pagina_estadistica.dart';

void main() => runApp(EstadisticaApp());

class EstadisticaApp extends StatelessWidget {
  const EstadisticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Estadística',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: PaginaSuscripciones(),
    );
  }
}
