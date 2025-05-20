import '../models/transaction.dart';

abstract class BudgetStrategy {
  bool isExceeded(double budgetLimit, List<Transaction> transactions);
}