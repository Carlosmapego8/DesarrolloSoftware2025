import 'package:test/test.dart';
import 'package:ejercicio_ds/account.dart';

void main() {
  test('No se permite depositar cantidades negativas o cero', () {
    final account = Account('AC999', 'Cristobal');

    expect(() => account.deposit(0), throwsArgumentError);
    expect(() => account.deposit(-10), throwsArgumentError);
  });
}