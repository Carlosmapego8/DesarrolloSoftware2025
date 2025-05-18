class Account {
  final String number;
  final String ownerName;
  double _balance = 0.0;

  Account(this.number, this.ownerName);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit must be positive');
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Withdrawal must be positive');
    if (_balance < amount) throw StateError('Insufficient funds');
    _balance -= amount;
  }
}
