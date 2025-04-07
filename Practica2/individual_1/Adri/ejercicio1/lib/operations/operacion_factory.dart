import '../models/operacion_estadistica.dart';
import 'media.dart';
import 'moda.dart';
import 'mediana.dart';
import 'varianza.dart';
import 'desviacion_estandar.dart';

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
