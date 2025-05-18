import 'package:test/test.dart';
import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';

void main() {
  group('WithdrawalTransaction', () {
    test('retira correctamente si hay fondos suficientes', () {
      final cuenta = Account('AC1', 'Alice')..deposit(100);
      final tx = WithdrawalTransaction('TX1', 40);

      tx.apply(cuenta);
      expect(cuenta.balance, 60);
    });

    test('lanza StateError si no hay fondos suficientes', () {
      final cuenta = Account('AC1', 'Alice')..deposit(30);
      final tx = WithdrawalTransaction('TX2', 50);

      expect(() => tx.apply(cuenta), throwsA(isA<StateError>()));
    });

    test('lanza ArgumentError si el monto es inválido', () {
      expect(() => WithdrawalTransaction('TX3', 0), throwsA(isA<ArgumentError>()));
      expect(() => WithdrawalTransaction('TX4', -20), throwsA(isA<ArgumentError>()));
    });
  });
}
