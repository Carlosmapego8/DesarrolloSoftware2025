import '../models/operacion_estadistica.dart';

class Media implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) =>
      datos.reduce((a, b) => a + b) / datos.length;
}
