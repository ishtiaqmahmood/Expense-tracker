import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstants {
  // App Info
  static const String appName = 'Pro Expense Tracker';
  static const String appVersion = '2.0.0';
  static const String appDescription = 'Smart Finance Management';

  // Supported Languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('zh', 'CN'),
    Locale('ja', 'JP'),
    Locale('hi', 'IN'),
  ];

  static const List localizationsDelegates = [];

  // Default Categories with icons and colors
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food & Dining', 'icon': Icons.restaurant, 'color': Color(0xFFFF6B6B)},
    {'name': 'Transportation', 'icon': Icons.directions_car, 'color': Color(0xFF4ECDC4)},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Color(0xFFFFD93D)},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Color(0xFF6BCB77)},
    {'name': 'Bills & Utilities', 'icon': Icons.receipt_long, 'color': Color(0xFF4D96FF)},
    {'name': 'Healthcare', 'icon': Icons.local_hospital, 'color': Color(0xFFFF6B9D)},
    {'name': 'Education', 'icon': Icons.school, 'color': Color(0xFFC780FA)},
    {'name': 'Personal Care', 'icon': Icons.spa, 'color': Color(0xFFFF9F45)},
    {'name': 'Home & Garden', 'icon': Icons.home, 'color': Color(0xFF2ECC71)},
    {'name': 'Insurance', 'icon': Icons.security, 'color': Color(0xFF3498DB)},
    {'name': 'Investments', 'icon': Icons.trending_up, 'color': Color(0xFF9B59B6)},
    {'name': 'Gifts & Donations', 'icon': Icons.card_giftcard, 'color': Color(0xFFE74C3C)},
    {'name': 'Travel', 'icon': Icons.flight, 'color': Color(0xFF1ABC9C)},
    {'name': 'Sports & Fitness', 'icon': Icons.fitness_center, 'color': Color(0xFFE67E22)},
    {'name': 'Pet Care', 'icon': Icons.pets, 'color': Color(0xFFF39C12)},
    {'name': 'Subscriptions', 'icon': Icons.repeat, 'color': Color(0xFF16A085)},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Color(0xFF95A5A6)},
  ];

  static const List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'icon': Icons.work, 'color': Color(0xFF2ECC71)},
    {'name': 'Business', 'icon': Icons.business, 'color': Color(0xFF3498DB)},
    {'name': 'Investments', 'icon': Icons.trending_up, 'color': Color(0xFF9B59B6)},
    {'name': 'Rental Income', 'icon': Icons.home_work, 'color': Color(0xFFE74C3C)},
    {'name': 'Gifts', 'icon': Icons.card_giftcard, 'color': Color(0xFFF39C12)},
    {'name': 'Refunds', 'icon': Icons.restore, 'color': Color(0xFF1ABC9C)},
    {'name': 'Freelance', 'icon': Icons.laptop, 'color': Color(0xFF27AE60)},
    {'name': 'Dividends', 'icon': Icons.pie_chart, 'color': Color(0xFF3498DB)},
    {'name': 'Interest', 'icon': Icons.account_balance, 'color': Color(0xFF16A085)},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Color(0xFF95A5A6)},
  ];

  // Currencies
  static const Map<String, String> currencies = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'INR': '₹',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'Fr',
    'KRW': '₩',
    'BRL': 'R\$',
    'RUB': '₽',
    'ZAR': 'R',
    'SGD': 'S\$',
    'HKD': 'HK\$',
    'MXN': '\$',
    'AED': 'د.إ',
    'SAR': '﷼',
  };

  // Color Palette
  static const Color primaryColor = Color(0xFF673AB7);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color incomeColor = Color(0xFF4CAF50);
  static const Color expenseColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);

  // Budget Periods
  static const List<String> budgetPeriods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  // Decimal Places
  static const int maxDecimalPlaces = 2;

  // Max PIN Length
  static const int maxPinLength = 6;

  // Notification Channel
  static const String notificationChannelId = 'pro_expense_tracker_channel';
  static const String notificationChannelName = 'Expense Reminders';

  // Database Names
  static const String databaseName = 'pro_expense_db';
  static const String settingsBoxName = 'settings_box';
  static const String authBoxName = 'auth_box';

  // Backup File Extension
  static const String backupFileExtension = '.proexpense';

  // Haptic Feedback
  static void hapticFeedback(int type) {
    HapticFeedback.vibrate();
  }

  // Vibration Patterns
  static Future<void> vibrateSuccess() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> vibrateError() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> vibrateWarning() async {
    await HapticFeedback.mediumImpact();
  }
}
