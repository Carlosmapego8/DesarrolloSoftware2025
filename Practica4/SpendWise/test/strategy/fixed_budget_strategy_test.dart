import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/budget_strategy.dart';
import 'package:spendwise/models/transaction.dart';

void main() {
  group('FixedBudgetStrategy', () {
    final strategy = FixedBudgetStrategy();

    test('No se excede el presupuesto si los gastos son menores al límite', () {
      final transactions = [
        Transaction(amount: 100.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Cena'),
        Transaction(amount: 50.0, category: 'Transporte', date: DateTime.now(), type: TransactionType.expense, name: 'Taxi'),
      ];
      expect(strategy.isExceeded(200.0, transactions), false);
    });

    test('Se excede el presupuesto si los gastos superan el límite', () {
      final transactions = [
        Transaction(amount: 150.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Cena'),
        Transaction(amount: 100.0, category: 'Transporte', date: DateTime.now(), type: TransactionType.expense, name: 'Taxi'),
      ];
      expect(strategy.isExceeded(200.0, transactions), true);
    });

    test('Los ingresos se restan de los gastos en el cálculo', () {
      final transactions = [
        Transaction(amount: 150.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Cena'),
        Transaction(amount: 100.0, category: 'Salario', date: DateTime.now(), type: TransactionType.income, name: 'Pago'),
      ];
      expect(strategy.isExceeded(100.0, transactions), false);
    });
  });
}
