import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(expense.itemName),
        subtitle: Text("${expense.category} • ${expense.date.toLocal().toString().split(' ')[0]}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("₹${expense.amount.toStringAsFixed(0)}"),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
