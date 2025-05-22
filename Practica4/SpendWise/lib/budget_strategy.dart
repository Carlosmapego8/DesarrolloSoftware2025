import 'models/transaction.dart';

abstract class BudgetStrategy {
  bool isExceeded(double budgetLimit, List<Transaction> transactions);
}

class AverageBasedStrategy implements BudgetStrategy {
  final double averageLastMonths;

  AverageBasedStrategy(this.averageLastMonths);

  @override
  bool isExceeded(double budgetLimit, List<Transaction> transactions) {
    double total = transactions.fold(0,
            (sum, t) => sum + (t.type == TransactionType.expense ? t.amount : -t.amount));
    double adjustedLimit = averageLastMonths * 1.1;
    return total > adjustedLimit;
  }
}


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

class FixedBudgetStrategy implements BudgetStrategy {
  @override
  bool isExceeded(double budgetLimit, List<Transaction> transactions) {
    double total = transactions.fold(0,
            (sum, t) => sum + (t.type == TransactionType.expense ? t.amount : -t.amount));
    return total > budgetLimit;
  }
}
