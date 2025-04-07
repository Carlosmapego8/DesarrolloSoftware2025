import 'package:flutter/material.dart';
import 'suscripcion.dart';
import 'gestor_suscripciones.dart';
import 'tarjeta_suscripcion.dart';

class PaginaSuscripciones extends StatefulWidget {
  const PaginaSuscripciones({super.key});

  @override
  _PaginaSuscripcionesState createState() => _PaginaSuscripcionesState();
}

class _PaginaSuscripcionesState extends State<PaginaSuscripciones> {
  final GestorSuscripciones _gestor = GestorSuscripciones();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  void _agregarSuscripcion() {
    final desc = _descController.text.trim();
    final precio = double.tryParse(_precioController.text.trim());

    final yaExiste = _gestor.suscripciones.any((s) => s.descripcion.toLowerCase() == desc.toLowerCase());

    if (desc.isNotEmpty && precio != null && precio >= 0.01 && !yaExiste) {
      setState(() {
        _gestor.agregar(Suscripcion(descripcion: desc, precioMensual: precio));
        _descController.clear();
        _precioController.clear();
      });
    }
  }

  void _eliminarSuscripcion(Suscripcion s) {
    setState(() {
      _gestor.eliminar(s);
    });
  }

  @override
  Widget build(BuildContext context) {
    final suscripciones = _gestor.suscripciones;
    final total = _gestor.obtenerTotalMensual();

    return Scaffold(
      appBar: AppBar(title: Text("Mis Suscripciones")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario de entrada
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Precio mensual (€)"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _agregarSuscripcion,
              child: Text("Agregar Suscripción"),
            ),
            Divider(height: 30),
            // Total mensual
            Text(
              "Costo total mensual: ${total.toStringAsFixed(2)} €",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Lista de suscripciones
            Expanded(
              child: ListView.builder(
                itemCount: suscripciones.length,
                itemBuilder: (context, index) {
                  final s = suscripciones[index];
                  return SuscripcionCard(
                    suscripcion: s,
                    onDelete: () => _eliminarSuscripcion(s),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
