enum TransactionType { income, expense }

class Transaction {
  double amount;
  String category;
  DateTime date;
  TransactionType type;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });
}