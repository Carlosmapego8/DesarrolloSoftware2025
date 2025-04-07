import '../models/operacion_estadistica.dart';

class Moda implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    final mapa = <double, int>{};
    for (var num in datos) {
      mapa[num] = (mapa[num] ?? 0) + 1;
    }
    var moda = datos.first;
    var max = 0;
    mapa.forEach((key, val) {
      if (val > max) {
        max = val;
        moda = key;
      }
    });
    return moda;
  }
}
