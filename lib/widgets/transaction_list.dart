import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../services/database_service.dart';
import '../utils/formatters.dart';

class TransactionList extends StatelessWidget {
  final List<Expense> transactions;
  final String currencySymbol;
  final bool hideAmounts;
  final Function(Expense)? onEdit;
  final Function(Expense)? onDelete;
  
  const TransactionList({
    super.key,
    required this.transactions,
    this.currencySymbol = '\$',
    this.hideAmounts = false,
    this.onEdit,
    this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first transaction',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: transactions.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isExpense = transaction.type == 'Expense';
        
        return Dismissible(
          key: Key(transaction.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Transaction'),
                content: const Text('Are you sure you want to delete this transaction?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            onDelete?.call(transaction);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: isExpense 
                    ? Colors.red.shade50 
                    : Colors.green.shade50,
                child: Icon(
                  isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
              title: Text(
                transaction.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.category} • ${Formatters.formatDate(transaction.date)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaction.note,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideAmounts ? '••••' : Formatters.formatCurrency(
                      transaction.amount,
                      symbol: currencySymbol,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                  if (transaction.isRecurring) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Recurring',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () => onEdit?.call(transaction),
            ),
          ),
        );
      },
    );
  }
}
