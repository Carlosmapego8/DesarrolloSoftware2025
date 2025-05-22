enum TransactionType { income, expense }

class Transaction {
  double amount;
  String category;
  DateTime date;
  TransactionType type;
  String name;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.name,
  });
}
