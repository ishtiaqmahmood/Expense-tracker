import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/settings.dart';
import 'database_service.dart';

class BackupService {
  Future<String> exportToJson() async {
    final db = DatabaseService.instance;
    final expenses = await db.expenses.where().findAll();
    final budgets = await db.budgets.where().findAll();
    final settingsList = await db.settings.where().findAll();
    
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
      final db = DatabaseService.instance;
      
      // Clear existing data
      await db.writeTxn(() async {
        await db.expenses.clear();
        await db.budgets.clear();
        await db.settings.clear();
      });
      
      // Import expenses
      if (data['expenses'] != null) {
        await db.writeTxn(() async {
          for (var expenseData in data['expenses']) {
            final expense = Expense.fromJson(expenseData);
            await db.expenses.put(expense);
          }
        });
      }
      
      // Import budgets
      if (data['budgets'] != null) {
        await db.writeTxn(() async {
          for (var budgetData in data['budgets']) {
            final budget = Budget.fromJson(budgetData);
            await db.budgets.put(budget);
          }
        });
      }
      
      // Import settings
      if (data['settings'] != null) {
        await db.writeTxn(() async {
          for (var settingsData in data['settings']) {
            final setting = Settings.fromJson(settingsData);
            await db.settings.put(setting);
          }
        });
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
