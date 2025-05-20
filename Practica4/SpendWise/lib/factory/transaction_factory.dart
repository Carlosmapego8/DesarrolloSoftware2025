import '../models/transaction.dart';

abstract class TransactionFactory {
  Transaction createTransaction(double amount, String category);
}

class ExpenseFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category) {
    return Transaction(
      amount: amount,
      category: category,
      date: DateTime.now(),
      type: TransactionType.expense,
    );
  }
}

class IncomeFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category) {
    return Transaction(
      amount: amount,
      category: category,
      date: DateTime.now(),
      type: TransactionType.income,
    );
  }
}
