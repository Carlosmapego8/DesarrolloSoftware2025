import 'package:test/test.dart';
import 'package:practica3/bank.dart';

void main() {
  group('transfer', () {
    test('lanza StateError cuando los fondos son insuficientes', () {
      final origen = Account('A')..deposit(50);
      final destino = Account('B');

      expect(() => transfer(origen, destino, 100), throwsA(isA<StateError>()));
    });
  });
}
