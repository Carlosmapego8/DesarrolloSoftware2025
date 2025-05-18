import 'package:test/test.dart';
import 'package:practica3/account.dart';

void main() {
  group('Account', () {
    test('El balance inicial de una cuenta debe ser cero', () {
      final account = Account('AC0', 'TEST');
      expect(account.balance, equals(0));
    });
  });


}