enum CurrencyType { EUR, USD, GBP }

extension CurrencyTypeExtension on CurrencyType {
  static CurrencyType fromInput(String input) {
    final cleaned = input.toUpperCase().replaceAll(RegExp(r'[()]'), '').trim();
    switch (cleaned) {
      case 'EUR':
      case '€':
        return CurrencyType.EUR;
      case 'USD':
      case '\$':
        return CurrencyType.USD;
      case 'GBP':
      case '£':
        return CurrencyType.GBP;
      default:
        throw ArgumentError('Moneda no válida: $input');
    }
  }

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

  String get label => '${name}(${symbol})';
}
