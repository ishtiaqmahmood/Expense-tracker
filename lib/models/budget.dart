import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;
  
  @Index()
  String category = '';
  
  double amount = 0.0;
  String period = 'monthly'; // daily, weekly, monthly, yearly
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool isActive = true;
  
  double get spentAmount => 0.0; // Will be calculated from expenses
  
  double get remainingAmount => amount - spentAmount;
  
  double get percentageUsed => amount > 0 ? (spentAmount / amount) * 100 : 0.0;
}
