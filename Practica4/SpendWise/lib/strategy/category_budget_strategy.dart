import 'budget_strategy.dart';
import '../models/transaction.dart';

class CategoryBudgetStrategy implements BudgetStrategy {
  final Map<String, double> categoryLimits;

  CategoryBudgetStrategy(this.categoryLimits);

  @override
  bool isExceeded(double budgetLimit, List<Transaction> transactions) {
    Map<String, double> spentByCategory = {};
    for (var t in transactions) {
      if (t.type == TransactionType.expense) {
        spentByCategory[t.category] =
            (spentByCategory[t.category] ?? 0) + t.amount;
      }
    }
    for (var category in categoryLimits.keys) {
      if ((spentByCategory[category] ?? 0) > categoryLimits[category]!) {
        return true;
      }
    }
    return false;
  }
}
