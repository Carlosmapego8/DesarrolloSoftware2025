import 'package:flutter/material.dart';
import '../models/suscripcion.dart';

class SuscripcionCard extends StatelessWidget {
  final Suscripcion suscripcion;
  final VoidCallback onDelete;

  const SuscripcionCard({
    super.key,
    required this.suscripcion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(suscripcion.descripcion),
        subtitle:
            Text("${suscripcion.precioMensual.toStringAsFixed(2)} € / mes"),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
