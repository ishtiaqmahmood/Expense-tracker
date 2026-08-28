import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/settings.dart';

class DatabaseService {
  static late Isar _isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ExpenseSchema, BudgetSchema, SettingsSchema],
      directory: dir.path,
    );
  }

  static Future<List<Expense>> getAllExpenses() async {
    return await _isar.expenses.where().sortByDateDesc().findAll();
  }

  static Future<List<Expense>> getExpensesByType(String type) async {
    return await _isar.expenses
        .filter()
        .typeEqualTo(type)
        .sortByDateDesc()
        .findAll();
  }

  static Future<void> addExpense(Expense expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.put(expense);
    });
  }

  static Future<void> deleteExpense(int id) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.delete(id);
    });
  }

  static Future<void> deleteAllExpenses() async {
    await _isar.writeTxn(() async {
      await _isar.expenses.clear();
    });
  }

  static Future<double> getTotalByType(String type) async {
    final expenses = await getExpensesByType(type);
    return expenses.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  static Future<Map<String, double>> getTotalsByCategory(String type) async {
    final expenses = await getExpensesByType(type);
    Map<String, double> categoryTotals = {};
    
    for (var expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    return categoryTotals;
  }

  static Future<List<Expense>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    return await _isar.expenses
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  static Future<void> updateExpense(Expense expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.put(expense);
    });
  }

  // Budget methods
  static Future<List<Budget>> getAllBudgets() async {
    return await _isar.budgets.where().findAll();
  }

  static Future<void> addBudget(Budget budget) async {
    await _isar.writeTxn(() async {
      await _isar.budgets.put(budget);
    });
  }

  static Future<void> deleteBudget(int id) async {
    await _isar.writeTxn(() async {
      await _isar.budgets.delete(id);
    });
  }

  // Settings methods
  static Future<Settings?> getSettings() async {
    return await _isar.settings.where().findFirst();
  }

  static Future<void> saveSettings(Settings settings) async {
    await _isar.writeTxn(() async {
      await _isar.settings.put(settings);
    });
  }

  // Get Isar instance for backup service
  static Isar get instance => _isar;
}
