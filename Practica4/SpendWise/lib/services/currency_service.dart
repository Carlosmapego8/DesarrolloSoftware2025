import '../models/currency_type.dart';

/// Singleton que gestiona la configuración actual de moneda y conversión de cantidades.
class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  /// Moneda actualmente seleccionada por el usuario.
  CurrencyType _current = CurrencyType.USD;

  /// Devuelve el tipo de moneda actualmente seleccionado.
  CurrencyType get currentCurrencyType => _current;

  /// Cambia la moneda actual a partir de un valor de entrada (label o símbolo).
  /// [input] es un String como "USD (\$)".
  void setCurrencyString(String input) {
    _current = CurrencyTypeExtension.fromInput(input);
  }

  /// Cambia la moneda actual a partir de un tipo de moneda.
  void setCurrencyType(CurrencyType type) {
    _current = type;
  }

  /// Convierte una cantidad (en EUR) a la moneda actual.
  /// [amount] es la cantidad en euros.
  /// Devuelve una cadena con el símbolo y la cantidad formateada.
  double convertToCurrent(double amount) {
    final factor = _current.conversionFactor;
    return amount * factor;
  }

  /// Convierte una cantidad de una moneda a otra.
  /// [amount] es la cantidad en la moneda de origen.
  /// [from] es la moneda de origen, [to] es la moneda destino.
  double convertFromTo(double amount, CurrencyType from, CurrencyType to) {
    // Primero convierte a EUR, luego a la moneda destino
    double amountInEur = amount / from.conversionFactor;
    return amountInEur * to.conversionFactor;
  }

  /// Devuelve la cantidad formateada con el símbolo de la moneda actual.
  /// Ejemplo: €123.45
  String formatCurrentCurrency(double amount, {bool signed = false}) {
    final prefix = signed ? '(-)' : '';
    return '$prefix${_current.symbol}${convertToCurrent(amount).abs().toStringAsFixed(2)}';
  }



  /// Devuelve la lista de labels para todas las monedas disponibles.
  List<String> getAllCurrencyLabels() {
    return CurrencyType.values.map((c) => c.label).toList();
  }
}

