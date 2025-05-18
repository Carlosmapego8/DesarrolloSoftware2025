import 'package:test/test.dart';
import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';

void main() {
  group('TransferTransaction', () {
    test('aplica transferencia correctamente entre cuentas', () {
      final origen = Account('AC1', 'Alice')..deposit(300);
      final destino = Account('AC2', 'Bob');

      final transaccion = TransferTransaction('TX1', 150, destino);
      transaccion.apply(origen);

      expect(origen.balance, 150);
      expect(destino.balance, 150);
    });

    test('lanza StateError si no hay fondos suficientes', () {
      final origen = Account('AC1', 'Alice')..deposit(50);
      final destino = Account('AC2', 'Bob');

      final transaccion = TransferTransaction('TX2', 100, destino);

      expect(() => transaccion.apply(origen), throwsA(isA<StateError>()));
    });

    test('lanza ArgumentError si el monto es cero o negativo', () {
      final destino = Account('AC2', 'Bob');

      expect(() => TransferTransaction('TX3', 0, destino), throwsA(isA<ArgumentError>()));
      expect(() => TransferTransaction('TX4', -10, destino), throwsA(isA<ArgumentError>()));
    });
  });
}