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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currencySymbol': currencySymbol,
      'currencyCode': currencyCode,
      'locale': locale,
      'isDarkMode': isDarkMode,
      'useSystemTheme': useSystemTheme,
      'isAppLockEnabled': isAppLockEnabled,
      'pinHash': pinHash,
      'isBiometricEnabled': isBiometricEnabled,
      'hideAmountsInPublic': hideAmountsInPublic,
      'budgetStartDate': budgetStartDate,
      'customCategories': customCategories,
      'lastBackupDate': lastBackupDate.toIso8601String(),
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings()
      ..id = json['id'] ?? Isar.autoIncrement
      ..currencySymbol = json['currencySymbol'] ?? '\$'
      ..currencyCode = json['currencyCode'] ?? 'USD'
      ..locale = json['locale'] ?? 'en_US'
      ..isDarkMode = json['isDarkMode'] ?? false
      ..useSystemTheme = json['useSystemTheme'] ?? true
      ..isAppLockEnabled = json['isAppLockEnabled'] ?? false
      ..pinHash = json['pinHash']
      ..isBiometricEnabled = json['isBiometricEnabled'] ?? false
      ..hideAmountsInPublic = json['hideAmountsInPublic'] ?? false
      ..budgetStartDate = json['budgetStartDate'] ?? 1
      ..customCategories = List<String>.from(json['customCategories'] ?? [])
      ..lastBackupDate = json['lastBackupDate'] != null 
          ? DateTime.parse(json['lastBackupDate']) 
          : DateTime.now();
  }
}
