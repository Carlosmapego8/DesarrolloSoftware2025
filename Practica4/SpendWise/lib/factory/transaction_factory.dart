import '../models/transaction.dart';

abstract class TransactionFactory {
  Transaction createTransaction(double amount, String category, DateTime date, String name);
}

class ExpenseFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category, DateTime date, String name) {
    return Transaction(
      amount: amount,
      category: category,
      date: date,
      type: TransactionType.expense,
      name: name,
    );
  }
}

class IncomeFactory implements TransactionFactory {
  @override
  Transaction createTransaction(double amount, String category, DateTime date, String name) {
    return Transaction(
      amount: amount,
      category: category,
      date: date,
      type: TransactionType.income,
      name: name,
    );
  }
}
