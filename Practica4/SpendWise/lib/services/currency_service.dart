import '../models/currency_type.dart';

class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  CurrencyType _current = CurrencyType.EUR;

  void setCurrency(String input) {
    _current = CurrencyTypeExtension.fromInput(input);
  }

  String convert(double amount) {
    final factor = _current.conversionFactor;
    final converted = amount * factor;
    final prefix = amount < 0 ? '(-)' : '';
    return '$prefix${_current.symbol}${converted.abs().toStringAsFixed(2)}';
  }

  String getCurrentCurrencyLabel() {
    return _current.label;
  }

  List<String> getAllCurrencyLabels() {
    return CurrencyType.values.map((c) => c.label).toList();
  }
}
