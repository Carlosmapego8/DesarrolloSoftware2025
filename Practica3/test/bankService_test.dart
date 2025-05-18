import 'package:test/test.dart';
import 'package:practica3/account.dart';
import 'package:practica3/bankService.dart';

void main() {
  group('BankService', () {
    test('withdraw lanza StateError cuando el saldo insuficiente', () {
      final bankService = BankService();
      bankService.registerUser('TEST');
      final account = bankService.createAccount('TEST');

      // Saldo inicial es 0, intentamos retirar 50
      expect(() => bankService.withdraw('TEST', account.number, 50),
          throwsA(isA<StateError>()));
    });

    test('Lista inicial de cuentas está vacía', () {
      final bankService = BankService();

      expect(bankService.listAllAccounts(), isEmpty);
    });

    test('deposit aumenta el saldo de la cuenta', () {
      final bankService = BankService();
      bankService.registerUser("Alice");
      final account = bankService.createAccount("Alice");
      bankService.deposit("Alice", account.number, 100.0);

      expect(bankService.getBalance(account.number), 100.0);
    });

    test('transfer mueve fondos correctamente', () {
      final bankService = BankService();
      bankService.registerUser("Bob");
      final from = bankService.createAccount("Bob");
      final to = bankService.createAccount("Bob");
      bankService.deposit("Bob", from.number, 200.0);
      bankService.transfer("Bob", from.number, to.number, 75.0);

      expect(bankService.getBalance(from.number), 125.0);
      expect(bankService.getBalance(to.number), 75.0);
    });

  });
}
