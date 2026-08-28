import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }

  static String formatCompactNumber(double number) {
    final formatter = NumberFormat.compact();
    return formatter.format(number);
  }

  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
