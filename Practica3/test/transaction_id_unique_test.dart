import 'package:test/test.dart';
import 'package:ejercicio_ds/bankService.dart';

void main() {
  test('txId genera identificadores únicos para muchas transacciones', () {
    final bank = BankService();
    bank.registerUser('Cristobal');

    // Crear 1000 cuentas y hacer un depósito en cada una
    for (int i = 0; i < 1000; i++) {
      final acc = bank.createAccount('Cristobal');
      bank.deposit('Cristobal', acc.number, 10.0);
    }

    final txIds = bank.transactionIds.toList();

    expect(txIds.toSet().length, txIds.length, reason: 'Los IDs deben ser únicos');
    expect(txIds.length, 1000, reason: 'Deben haberse generado 1000 transacciones');
  });
}
