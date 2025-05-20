import '../models/transaction.dart';

abstract class TransactionFactory {
  Transaction createTransaction(double amount, String category, DateTime date);
}

class ExpenseFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category, DateTime date) {
    return Transaction(
      amount: amount,
      category: category,
      date: date,
      type: TransactionType.expense,
    );
  }
}

class IncomeFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category, DateTime date) {
    return Transaction(
      amount: amount,
      category: category,
      date: date,
      type: TransactionType.income,
    );
  }
}
