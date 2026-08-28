import 'package:flutter/material.dart';

class AppConstants {
  // Default categories with icons and colors
  static const List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.red},
    {'name': 'Bills', 'icon': Icons.receipt_long, 'color': Colors.brown},
    {'name': 'Health', 'icon': Icons.local_hospital, 'color': Colors.green},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.indigo},
    {'name': 'Travel', 'icon': Icons.flight, 'color': Colors.teal},
    {'name': 'Personal Care', 'icon': Icons.spa, 'color': Colors.pink},
    {'name': 'Home', 'icon': Icons.home, 'color': Colors.amber},
    {'name': 'Insurance', 'icon': Icons.security, 'color': Colors.grey},
    {'name': 'Savings', 'icon': Icons.savings, 'color': Colors.emerald},
    {'name': 'Investment', 'icon': Icons.trending_up, 'color': Colors.lightGreen},
    {'name': 'Gift', 'icon': Icons.card_giftcard, 'color': Colors.deepPurple},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.slate},
  ];

  static const List<String> transactionTypes = ['Expense', 'Income'];
  
  static const List<String> budgetPeriods = ['daily', 'weekly', 'monthly', 'yearly'];
  
  static const List<Map<String, String>> currencies = [
    {'symbol': '\$', 'code': 'USD', 'name': 'US Dollar'},
    {'symbol': '€', 'code': 'EUR', 'name': 'Euro'},
    {'symbol': '£', 'code': 'GBP', 'name': 'British Pound'},
    {'symbol': '¥', 'code': 'JPY', 'name': 'Japanese Yen'},
    {'symbol': '₹', 'code': 'INR', 'name': 'Indian Rupee'},
    {'symbol': '₿', 'code': 'BTC', 'name': 'Bitcoin'},
  ];

  static const Duration animationDuration = Duration(milliseconds: 300);
  
  static const int maxDecimalPlaces = 2;
}
