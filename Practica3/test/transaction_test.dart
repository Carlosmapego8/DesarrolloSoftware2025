import 'package:test/test.dart';
import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';

void main() {
  group('Transaction', () {
    test('DepositTransaction.apply aumenta el saldo correctamente', () {
      final account = Account('AC1000', 'Cristobal');
      final tx = DepositTransaction('TX1', 50.0);

      tx.apply(account);

      expect(account.balance, 50.0);
    });

    test('WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes', () {
      final account = Account('AC0', 'Test'); // balance = 0
      final transaction = WithdrawalTransaction('TX0', 100);

      expect(() => transaction.apply(account), throwsA(isA<StateError>()));
    });

    test('TransferTransaction.apply mueve fondos entre cuentas de forma correcta', () {
      final origen = Account('AC1', 'Alice')..deposit(300);
      final destino = Account('AC2', 'Bob');

      final transaccion = TransferTransaction('TX1', 150, destino);
      transaccion.apply(origen);

      expect(origen.balance, 150);
      expect(destino.balance, 150);
    });
  });
}
