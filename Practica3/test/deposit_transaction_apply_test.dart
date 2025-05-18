import 'package:test/test.dart';
import 'package:ejercicio_ds/account.dart';
import 'package:ejercicio_ds/transaction.dart';

void main() {
  test('DepositTransaction.apply aumenta el saldo correctamente', () {
    final account = Account('AC1000', 'Cristobal');
    final tx = DepositTransaction('TX1', 50.0);

    tx.apply(account);

    expect(account.balance, 50.0);
  });
}
