import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;
  final String category;
  final String type; // 'income' or 'expense'

  Expense({
    required this.name,
    required this.amount,
    required this.date,
    this.category = 'Other',
    this.type = 'expense',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      category: json['category'] ?? 'Other',
      type: json['type'] ?? 'expense',
    )..id = json['id'] ?? Isar.autoIncrement;
  }
}