import 'package:flutter/material.dart';
import 'screens/estadistica_page.dart';

void main() => runApp(EstadisticaApp());

class EstadisticaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Estadística',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: EstadisticaPage(),
    );
  }
}
