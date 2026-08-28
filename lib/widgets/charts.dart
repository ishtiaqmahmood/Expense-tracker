import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;
  final String type;

  const ExpenseChart({
    super.key,
    required this.expenses,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = expenses.where((e) => e.type == type).toList();
    
    if (filteredExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    Map<String, double> categoryTotals = {};
    for (var expense in filteredExpenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    List<PieChartSectionData> sections = [];
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
    ];

    int index = 0;
    categoryTotals.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          value: amount,
          title: '$category\n\$${amount.toStringAsFixed(0)}',
          color: colors[index % colors.length],
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          startDegreeOffset: -90,
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Expense> expenses;

  const BarChartWidget({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No data for chart',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Group expenses by date (last 7 days)
    Map<String, double> dailyTotals = {};
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.month}/${date.day}';
      dailyTotals[key] = 0;
    }

    for (var expense in expenses) {
      final key = '${expense.date.month}/${expense.date.day}';
      if (dailyTotals.containsKey(key)) {
        dailyTotals[key] = (dailyTotals[key] ?? 0) + expense.amount;
      }
    }

    List<BarChartGroupData> groups = [];
    int index = 0;
    
    dailyTotals.forEach((date, amount) {
      groups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: amount > 0 ? Colors.blue : Colors.grey,
              width: 20,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
      index++;
    });

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: dailyTotals.values.isEmpty 
              ? 100 
              : dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(2)}',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < dailyTotals.keys.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        dailyTotals.keys.elementAt(value.toInt()),
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(fontSize: 10),
                  );
                },
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: groups,
        ),
      ),
    );
  }
}
