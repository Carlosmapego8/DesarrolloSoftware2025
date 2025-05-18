import 'package:test/test.dart';
import 'package:practica3/account.dart';

void main() {
  group('Account', () {
    test('El balance inicial de una cuenta debe ser cero', () {
      final account = Account('AC0', 'TEST');
      expect(account.balance, equals(0));
    });

    test('No se permite depositar cantidades negativas o cero', () {
      final account = Account('AC999', 'Cristobal');

      expect(() => account.deposit(0), throwsArgumentError);
      expect(() => account.deposit(-10), throwsArgumentError);
    });

    test('No se permite retirar cantidades negativas o cero', () {
      final account = Account('AC100', 'Test')..deposit(100);

      expect(() => account.withdraw(0), throwsArgumentError);
      expect(() => account.withdraw(-20), throwsArgumentError);
    });
  });
}
