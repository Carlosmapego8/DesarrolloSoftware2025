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
  });
}
