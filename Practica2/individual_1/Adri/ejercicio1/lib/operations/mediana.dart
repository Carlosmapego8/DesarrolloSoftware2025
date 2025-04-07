import '../models/operacion_estadistica.dart';

class Mediana implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    datos.sort();
    int n = datos.length;
    return n % 2 == 0
        ? (datos[n ~/ 2 - 1] + datos[n ~/ 2]) / 2
        : datos[n ~/ 2];
  }
}
