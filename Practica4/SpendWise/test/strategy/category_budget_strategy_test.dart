import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/budget_strategy.dart';
import 'package:spendwise/models/transaction.dart';

void main() {
  group('CategoryBudgetStrategy', () {
    final categoryLimits = {'Comida': 100.0, 'Transporte': 50.0};
    final strategy = CategoryBudgetStrategy(categoryLimits);

    test('No se excede ninguna categoría', () {
      final transactions = [
        Transaction(amount: 80.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Compra'),
        Transaction(amount: 30.0, category: 'Transporte', date: DateTime.now(), type: TransactionType.expense, name: 'Bus'),
      ];
      expect(strategy.isExceeded(0.0, transactions), false);
    });

    test('Se excede el límite en la categoría "Comida"', () {
      final transactions = [
        Transaction(amount: 120.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Cena cara'),
      ];
      expect(strategy.isExceeded(0.0, transactions), true);
    });

    test('Ignora transacciones fuera del mapa de categorías', () {
      final transactions = [
        Transaction(amount: 100.0, category: 'Salud', date: DateTime.now(), type: TransactionType.expense, name: 'Dentista'),
      ];
      expect(strategy.isExceeded(0.0, transactions), false);
    });
  });
}
