import 'account.dart';

abstract class Transaction {
  final String id;
  final double amount;

  Transaction(this.id, this.amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
  }

  void apply(Account account);
}

class DepositTransaction extends Transaction {
  DepositTransaction(String id, double amount) : super(id, amount);

  @override
  void apply(Account account) {
    account.deposit(amount);
  }
}

class WithdrawalTransaction extends Transaction {
  WithdrawalTransaction(String id, double amount) : super(id, amount);

  @override
  void apply(Account account) {
    account.withdraw(amount);
  }
}


class TransferTransaction extends Transaction {
  final Account destinationAccount;

  TransferTransaction(String id, double amount, this.destinationAccount)
      : super(id, amount);

  @override
  void apply(Account sourceAccount) {
    sourceAccount.withdraw(amount);
    destinationAccount.deposit(amount);
  }
}

