import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/transaction.dart';
import 'package:spendwise/services/transaction_api_controller.dart';

void main() {
  final api = TransactionApiController();
  late Transaction created;

  group('Transaction API via Controller', () {
    test('GET → fetchTransactions() carga elementos', () async {
      await api.fetchTransactions();
      expect(api.transactions, isA<List<Transaction>>());
    });

    test('POST → createTransaction() añade elemento', () async {
      final tx = Transaction(
        amount: 50.0,
        category: 'Prueba',
        date: DateTime.now(),
        type: TransactionType.income,
        name: 'Ingreso test',
      );

      final id = await api.createTransaction(tx);
      await api.fetchTransactions();
      created = api.transactions.firstWhere((t) => t.id == id);

      expect(created.name, equals('Ingreso test'));
    });

    test('PATCH → updateTransaction() modifica elemento', () async {
      created.name = 'Ingreso actualizado';
      await api.updateTransaction(created.id, created);
      await api.fetchTransactions();

      final updated = api.transactions.firstWhere((t) => t.id == created.id);
      expect(updated.name, equals('Ingreso actualizado'));
    });

    test('DELETE → deleteTransaction() elimina elemento', () async {
      await api.deleteTransaction(created.id);
      await api.fetchTransactions();

      final exists = api.transactions.any((t) => t.id == created.id);
      expect(exists, isFalse);
    });
  });
}
