import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String _filterType = 'all'; // all, income, expense
  DateTime? _startDate;
  DateTime? _endDate;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String get filterType => _filterType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  double get totalIncome =>
      _expenses.where((e) => e.type == 'income').fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense =>
      _expenses.where((e) => e.type == 'expense').fold(0.0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  List<Expense> get filteredExpenses {
    var filtered = _expenses;

    if (_filterType != 'all') {
      filtered = filtered.where((e) => e.type == _filterType).toList();
    }

    if (_startDate != null && _endDate != null) {
      filtered = filtered
          .where((e) =>
              e.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              e.date.isBefore(_endDate!.add(const Duration(days: 1))))
          .toList();
    }

    return filtered;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await DatabaseService.getAllExpenses();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseService.addExpense(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseService.updateExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(Id id) async {
    await DatabaseService.deleteExpense(id);
    await loadExpenses();
  }

  Future<void> deleteAllExpenses() async {
    await DatabaseService.deleteAllExpenses();
    await loadExpenses();
  }

  void setFilter(String type) {
    _filterType = type;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearDateRange() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  Map<String, double> getCategoryTotals(String type) {
    final expensesOfType = _expenses.where((e) => e.type == type).toList();
    Map<String, double> categoryTotals = {};

    for (var expense in expensesOfType) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  Future<void> importExpenses(List<Expense> newExpenses) async {
    for (var expense in newExpenses) {
      await DatabaseService.addExpense(expense);
    }
    await loadExpenses();
  }
}
