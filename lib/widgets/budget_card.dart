import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../utils/formatters.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final double spentAmount;
  final VoidCallback? onTap;
  
  const BudgetCard({
    super.key,
    required this.budget,
    required this.spentAmount,
    this.onTap,
  });
  
  Color get _progressColor {
    final percentage = budget.amount > 0 ? (spentAmount / budget.amount) * 100 : 0;
    if (percentage >= 100) return Colors.red;
    if (percentage >= 75) return Colors.orange;
    return Colors.green;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = budget.amount - spentAmount;
    final percentage = budget.amount > 0 ? (spentAmount / budget.amount) * 100 : 0;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    budget.category,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      budget.period.toUpperCase(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(budget.amount),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Spent',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(spentAmount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _progressColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Formatters.percentage(percentage)} used',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    remaining >= 0 
                        ? '${Formatters.formatCurrency(remaining)} left'
                        : '${Formatters.formatCurrency(remaining.abs())} over',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: remaining >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
