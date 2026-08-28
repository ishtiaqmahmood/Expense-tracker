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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget()
      ..id = json['id'] ?? Isar.autoIncrement
      ..category = json['category'] ?? ''
      ..amount = (json['amount'] ?? 0).toDouble()
      ..period = json['period'] ?? 'monthly'
      ..startDate = json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now()
      ..endDate = json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : null
      ..isActive = json['isActive'] ?? true;
  }
}
