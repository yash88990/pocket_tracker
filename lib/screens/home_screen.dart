import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../utils/expense_helper.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box box = Hive.box('expensesBox');

  // Load expenses from Hive
  List<Expense> get expenses {
    return box.values.map((e) {
      return Expense(
        itemName: e['item'],
        category: e['category'],
        amount: e['amount'],
        date: DateTime.parse(e['date']),
      );
    }).toList();
  }

  // Add expense
  void addExpense(Expense expense) {
    box.add({
      'item': expense.itemName,
      'category': expense.category,
      'amount': expense.amount,
      'date': expense.date.toString(),
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final total = ExpenseHelper.totalExpense(expenses);
    final categoryData = ExpenseHelper.categoryWise(expenses);
    final sortedCategory = ExpenseHelper.prioritySort(categoryData);

    return Scaffold(
      appBar: AppBar(title: const Text("PocketTracker")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(onAdd: addExpense),
            ),
          );
        },
      ),
      body: Column(
        children: [
          // Total
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Total Spent: ₹${total.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Category-wise report (last 30 days)
          if (sortedCategory.isNotEmpty)
            Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: sortedCategory
                    .map(
                      (e) => ListTile(
                        title: Text(e.key),
                        trailing:
                            Text("₹${e.value.toStringAsFixed(0)}"),
                      ),
                    )
                    .toList(),
              ),
            ),

          // Expense List
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (_, i) {
                return ExpenseCard(
                  expense: expenses[i],
                  onDelete: () {
                    box.deleteAt(i);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
