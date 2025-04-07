import 'operacion_estadistica.dart';

class OperacionEstadisticaFactory {
  static OperacionEstadistica crearOperacion(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'media':
        return Media();
      case 'moda':
        return Moda();
      case 'mediana':
        return Mediana();
      case 'varianza':
        return Varianza();
      case 'desviación estándar':
        return DesviacionEstandar();
      default:
        throw Exception('Operación no soportada');
    }
  }
}
