import 'dart:math';
import '../models/operacion_estadistica.dart';

class Varianza implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    final media = datos.reduce((a, b) => a + b) / datos.length;
    return datos.map((x) => pow(x - media, 2)).reduce((a, b) => a + b) / datos.length;
  }
}
