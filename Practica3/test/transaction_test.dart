import 'package:test/test.dart';
import 'package:practica3/transaction.dart';
import 'package:practica3/account.dart';

void main() {
  group('Transaction', () {
    test(
      'WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes',
          () {
        final account = Account('AC0', 'Test'); // balance = 0
        final transaction = WithdrawalTransaction('TX0',100);

        expect(() => transaction.apply(account), throwsA(isA<StateError>()));
      },
    );
  });
}