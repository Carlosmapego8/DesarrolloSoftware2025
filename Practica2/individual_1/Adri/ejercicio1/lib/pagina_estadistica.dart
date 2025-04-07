import 'package:flutter/material.dart';
import 'factoria_operacion.dart';
import 'grafico_barras.dart';

class PaginaSuscripciones extends StatefulWidget {
  const PaginaSuscripciones({super.key});

  @override
  _PaginaSuscripcionesState createState() => _PaginaSuscripcionesState();
}

class _PaginaSuscripcionesState extends State<PaginaSuscripciones> {
  final TextEditingController _controller = TextEditingController();
  String _resultado = "";
  String _operacionSeleccionada = 'media';
  List<double> _datos = [];

  void _calcular() {
    try {
      final datos = _controller.text
          .split(',')
          .map((e) => double.parse(e.trim()))
          .toList();

      final operacion = OperacionEstadisticaFactory.crearOperacion(_operacionSeleccionada);
      final resultado = operacion.calcular(datos);

      setState(() {
        _datos = datos;
        _resultado =
            "${_operacionSeleccionada.toUpperCase()}: ${resultado.toStringAsFixed(2)}";
      });
    } catch (e) {
      setState(() {
        _resultado = "Error: Verifica el formato de los datos.";
        _datos = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final operaciones = [
      'media',
      'moda',
      'mediana',
      'varianza',
      'desviación estándar'
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Estadística")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Ingrese números separados por comas",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _operacionSeleccionada,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _operacionSeleccionada = value!;
                });
              },
              items: operaciones
                  .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _calcular,
              child: Text("Calcular"),
            ),
            SizedBox(height: 20),
            Text(
              _resultado,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            if (_datos.isNotEmpty)
              Expanded(child: GraficoBarras(datos: _datos)),
          ],
        ),
      ),
    );
  }
}
