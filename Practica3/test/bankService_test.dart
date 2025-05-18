import 'package:test/test.dart';
import 'package:practica3/account.dart';
import 'package:practica3/bankService.dart';

void main() {
  group('BankService', () {
    test('La lista inicial de cuentas está vacía', () {
      final bank = BankService();
      expect(bank.accounts, isEmpty);
    });

    test('deposit aumenta el saldo de la cuenta', () {
      final bank = BankService();
      bank.registerUser('User1');
      final account = bank.createAccount('User1');
      bank.deposit('User1', account.number, 100);
      expect(account.balance, 100);
    });

    test('withdraw lanza StateError cuando el saldo insuficiente', () {
      final bank = BankService();
      bank.registerUser('TEST');
      final account = bank.createAccount('TEST');

      expect(() => bank.withdraw('TEST', account.number, 50),
          throwsA(isA<StateError>()));
    });

    test('transfer mueve fondos correctamente', () {
      final bank = BankService();
      bank.registerUser('User1');
      final origen = bank.createAccount('User1');
      final destino = bank.createAccount('User1');

      bank.deposit('User1', origen.number, 200);
      bank.transfer('User1', origen.number, destino.number, 100);

      expect(origen.balance, 100);
      expect(destino.balance, 100);
    });

    test('transfer lanza StateError cuando los fondos son insuficientes', () {
      final bank = BankService();
      bank.registerUser('User1');
      final origen = bank.createAccount('User1');
      final destino = bank.createAccount('User1');

      expect(() => bank.transfer('User1', origen.number, destino.number, 50),
          throwsA(isA<StateError>()));
    });

    test('txId genera identificadores únicos', () {
      final bank = BankService();
      bank.registerUser('Cristobal');

      for (int i = 0; i < 1000; i++) {
        final acc = bank.createAccount('Cristobal');
        bank.deposit('Cristobal', acc.number, 10.0);
      }

      final txIds = bank.transactionIds.toList();
      expect(txIds.toSet().length, txIds.length, reason: 'Los IDs deben ser únicos');
      expect(txIds.length, 1000, reason: 'Deben haberse generado 1000 transacciones');
    });
  });
}
