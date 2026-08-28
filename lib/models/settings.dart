import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;
  
  String currencySymbol = '\$';
  String currencyCode = 'USD';
  String locale = 'en_US';
  
  bool isDarkMode = false;
  bool useSystemTheme = true;
  
  bool isAppLockEnabled = false;
  String? pinHash;
  bool isBiometricEnabled = false;
  
  bool hideAmountsInPublic = false;
  
  int budgetStartDate = 1; // Day of month
  
  List<String> customCategories = [];
  
  DateTime lastBackupDate = DateTime.now();
}
