import 'budget_strategy.dart';
import '../models/transaction.dart';

class FixedBudgetStrategy implements BudgetStrategy {
  @override
  bool isExceeded(double budgetLimit, List<Transaction> transactions) {
    double total = transactions.fold(0,
            (sum, t) => sum + (t.type == TransactionType.expense ? t.amount : -t.amount));
    return total > budgetLimit;
  }
}
