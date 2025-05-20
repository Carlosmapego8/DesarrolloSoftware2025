import 'budget_strategy.dart';
import '../models/transaction.dart';

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
