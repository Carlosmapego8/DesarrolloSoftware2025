/// Enum que representa los tipos de moneda admitidos en la aplicación.
enum CurrencyType { EUR, USD, GBP }

/// Extensión sobre CurrencyType para proporcionar utilidades relacionadas con formato y conversión.
extension CurrencyTypeExtension on CurrencyType {
  /// Devuelve un CurrencyType a partir de una entrada de texto como "EUR" o "€".
  /// Lanza ArgumentError si la entrada no es válida.
  static CurrencyType fromInput(String input) {
    final cleaned = input.toUpperCase().replaceAll(RegExp(r'[()]'), '').trim();
    switch (cleaned) {
      case 'EUR€':
        return CurrencyType.EUR;
      case 'USD\$':
        return CurrencyType.USD;
      case 'GBP£':
        return CurrencyType.GBP;
      default:
        throw ArgumentError('Moneda no válida: $input');
    }
  }

  /// Devuelve el símbolo asociado a cada tipo de moneda.
  String get symbol {
    switch (this) {
      case CurrencyType.EUR:
        return '€';
      case CurrencyType.USD:
        return '\$';
      case CurrencyType.GBP:
        return '£';
    }
  }

  /// Devuelve el factor de conversión respecto al EUR (base).
  /// EUR = 1.0, USD = 1.09, GBP = 0.85
  double get conversionFactor {
    switch (this) {
      case CurrencyType.EUR:
        return 1.0;
      case CurrencyType.USD:
        return 1.09;
      case CurrencyType.GBP:
        return 0.85;
    }
  }

  /// Devuelve una etiqueta legible como "USD(\$)" o "EUR(€)".
  String get label => '${name}(${symbol})';
}
