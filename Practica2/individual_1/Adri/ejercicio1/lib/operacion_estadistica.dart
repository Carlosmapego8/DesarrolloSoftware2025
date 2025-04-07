import 'dart:math';

abstract class OperacionEstadistica {
  double calcular(List<double> datos);
}

class Varianza implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    final media = datos.reduce((a, b) => a + b) / datos.length;
    return datos.map((x) => pow(x - media, 2)).reduce((a, b) => a + b) / datos.length;
  }
}

class DesviacionEstandar implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) {
    final varianza = Varianza().calcular(datos);
    return sqrt(varianza);
  }
}

class Media implements OperacionEstadistica {
  @override
  double calcular(List<double> datos) =>
      datos.reduce((a, b) => a + b) / datos.length;
}

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
