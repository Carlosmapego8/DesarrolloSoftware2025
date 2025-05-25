import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/budget_strategy.dart';
import 'package:spendwise/models/transaction.dart';

void main() {
  group('AverageBasedStrategy', () {
    final averageLastMonths = 500.0;
    final strategy = AverageBasedStrategy(averageLastMonths);

    test('No se excede el 10% del promedio', () {
      final transactions = [
        Transaction(amount: 200.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Compra'),
        Transaction(amount: 300.0, category: 'Transporte', date: DateTime.now(), type: TransactionType.expense, name: 'Taxi'),
      ];
      expect(strategy.isExceeded(0.0, transactions), false);
    });

    test('Se excede el 10% del promedio', () {
      final transactions = [
        Transaction(amount: 400.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Compra grande'),
        Transaction(amount: 200.0, category: 'Transporte', date: DateTime.now(), type: TransactionType.expense, name: 'Taxi largo'),
      ];
      expect(strategy.isExceeded(0.0, transactions), true);
    });

    test('Los ingresos reducen el total de gastos', () {
      final transactions = [
        Transaction(amount: 600.0, category: 'Comida', date: DateTime.now(), type: TransactionType.expense, name: 'Comida'),
        Transaction(amount: 100.0, category: 'Salario', date: DateTime.now(), type: TransactionType.income, name: 'Ingreso'),
      ];
      expect(strategy.isExceeded(0.0, transactions), false);
    });
  });
}
