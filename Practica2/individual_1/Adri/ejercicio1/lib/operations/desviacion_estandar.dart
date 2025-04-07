import 'dart:math';
import '../models/operacion_estadistica.dart';
import 'varianza.dart';

class DesviacionEstandar implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    final varianza = Varianza().calcular(datos);
    return sqrt(varianza);
  }
}
