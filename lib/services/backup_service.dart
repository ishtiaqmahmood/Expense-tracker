import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/settings.dart';
import 'database_service.dart';

class BackupService {
  Future<String> exportToJson() async {
    final expenses = await DatabaseService.getAllExpenses();
    final budgets = await DatabaseService.getAllBudgets();
    final settingsOpt = await DatabaseService.getSettings();
    final settingsList = settingsOpt != null ? [settingsOpt] : <Settings>[];

    final data = {
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'budgets': budgets.map((b) => b.toJson()).toList(),
      'settings': settingsList.map((s) => s.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<File?> saveBackupToFile(String jsonData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/proexpense_backup_$timestamp.json');
      await file.writeAsString(jsonData);
      return file;
    } catch (e) {
      print('Error saving backup: $e');
      return null;
    }
  }

  Future<File?> pickAndImportBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  Future<bool> importFromJson(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;

      // Import expenses
      if (data['expenses'] != null) {
        for (var expenseData in data['expenses']) {
          final expense = Expense.fromJson(expenseData);
          await DatabaseService.addExpense(expense);
        }
      }

      // Import budgets
      if (data['budgets'] != null) {
        for (var budgetData in data['budgets']) {
          final budget = Budget.fromJson(budgetData);
          await DatabaseService.addBudget(budget);
        }
      }

      // Import settings
      if (data['settings'] != null && data['settings'].isNotEmpty) {
        final setting = Settings.fromJson(data['settings'][0]);
        await DatabaseService.saveSettings(setting);
      }

      return true;
    } catch (e) {
      print('Error importing JSON: $e');
      return false;
    }
  }

  Future<String?> getBackupFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/backups';
  }
}
