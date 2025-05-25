enum TransactionType { income, expense }

class Transaction {
  String id;
  double amount;
  String category;
  DateTime date;
  TransactionType type;
  String name;

  Transaction({
    this.id = '',
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.name,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      amount: double.parse(json['amount'].toString()),
      category: json['category'],
      date: DateTime.parse(json['date']),
      type: TransactionType.values.byName(json['tipo']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'tipo': type.name,
      'name': name,
    };
  }

}
