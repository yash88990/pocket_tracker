import '../models/expense.dart';

class ExpenseHelper {

  // Total spending
  static double totalExpense(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  // Category-wise expense (last 30 days)
  static Map<String, double> categoryWise(List<Expense> expenses) {
    Map<String, double> result = {};
    DateTime lastMonth = DateTime.now().subtract(const Duration(days: 30));

    for (var e in expenses) {
      if (e.date.isAfter(lastMonth)) {
        result[e.category] = (result[e.category] ?? 0) + e.amount;
      }
    }
    return result;
  }

  // Sort by highest spend
  static List<MapEntry<String, double>> prioritySort(
      Map<String, double> data) {
    final list = data.entries.toList();
    list.sort((a, b) => b.value.compareTo(a.value));
    return list;
  }
}
