import '../models/currency_type.dart';

/// Singleton que gestiona la configuración actual de moneda y conversión de cantidades.
class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  /// Moneda actualmente seleccionada por el usuario.
  CurrencyType _current = CurrencyType.EUR;

  /// Cambia la moneda actual a partir de un valor de entrada (label o símbolo).
  /// [input] es un String como "USD (\$)".
    _current = CurrencyTypeExtension.fromInput(input);
  }

  /// Cambia la moneda actual a partir de un tipo de moneda.
  void setCurrencyType(CurrencyType type) {
    _current = type;
  }

  /// Convierte una cantidad (en EUR) a la moneda actual.
  /// [amount] es la cantidad en euros.
  /// Devuelve una cadena con el símbolo y la cantidad formateada.
  String convert(double amount) {
    final factor = _current.conversionFactor;
    final converted = amount * factor;
    final prefix = amount < 0 ? '(-)' : '';
    return '$prefix${_current.symbol}${converted.abs().toStringAsFixed(2)}';
  }

  /// Convierte una cantidad de una moneda a otra.
  /// [amount] es la cantidad en la moneda de origen.
  /// [from] es la moneda de origen, [to] es la moneda destino.
    double amountInEur = amount / from.conversionFactor;
    return amountInEur * to.conversionFactor;
  /// Devuelve el tipo de moneda actualmente seleccionado.
  CurrencyType get currentCurrencyType => _current;

  /// Devuelve el label formateado de la moneda actual (por ejemplo: "USD (\$)").
  String getCurrentCurrencyLabel() {
    return _current.label;
  }

  /// Devuelve la lista de labels para todas las monedas disponibles.
  List<String> getAllCurrencyLabels() {
    return CurrencyType.values.map((c) => c.label).toList();
  }
}

