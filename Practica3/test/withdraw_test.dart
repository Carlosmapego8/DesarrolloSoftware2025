import 'package:test/test.dart';
import 'package:practica3/bank.dart';

void main() {
  group('Withdraw con cantidades no válidas', () {
    test('No se permite retirar cantidades negativas o cero', () {
      final cuenta = Account('A');
      expect(() => cuenta.withdraw(0), throwsA(isA<StateError>()));
      expect(() => cuenta.withdraw(-50), throwsA(isA<StateError>()));
    });
  });
}