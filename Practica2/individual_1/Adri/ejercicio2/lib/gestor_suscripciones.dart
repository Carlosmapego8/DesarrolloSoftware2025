import 'suscripcion.dart';

class GestorSuscripciones {
  final List<Suscripcion> _suscripciones = [];

  List<Suscripcion> get suscripciones => List.unmodifiable(_suscripciones);

  void agregar(Suscripcion s) {
    _suscripciones.add(s);
  }

  void eliminar(Suscripcion s) {
    _suscripciones.remove(s);
  }

  double obtenerTotalMensual() {
    return _suscripciones.fold(0, (total, s) => total + s.precioMensual);
  }
}
