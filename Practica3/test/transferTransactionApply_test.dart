import 'package:test/test.dart';
import 'package:practica3/bank.dart';

void main() {
  group('TransferTransaction', () {
    test('apply mueve fondos correctamente entre cuentas', () {
      final origen = Account('A')..deposit(300);
      final destino = Account('B');

      final transaccion = TransferTransaction(150);
      transaccion.apply(origen, destino);

      expect(origen.balance, 150);
      expect(destino.balance, 150);
    });
  });
}
