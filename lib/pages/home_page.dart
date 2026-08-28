import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/expense.dart';
import '../services/database_service.dart';
import '../services/export_service.dart';
import '../widgets/charts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<Expense> _expenses = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  bool _isLoading = true;
  late TabController _tabController;
  String _selectedFilter = 'all';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Salary',
    'Investment',
    'Gift',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExpenses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    try {
      final expenses = await DatabaseService.getAllExpenses();
      setState(() {
        _expenses = expenses;
        _totalIncome = expenses
            .where((e) => e.type == 'income')
            .fold(0.0, (sum, item) => sum + item.amount);
        _totalExpense = expenses
            .where((e) => e.type == 'expense')
            .fold(0.0, (sum, item) => sum + item.amount);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading expenses: $e')),
        );
      }
    }
  }

  List<Expense> get _filteredExpenses {
    if (_selectedFilter == 'income') {
      return _expenses.where((e) => e.type == 'income').toList();
    } else if (_selectedFilter == 'expense') {
      return _expenses.where((e) => e.type == 'expense').toList();
    }
    return _expenses;
  }

  void _showAddExpenseDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = _categories.first;
    String selectedType = 'expense';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'expense',
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: 'income',
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {selectedType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setDialogState(() {
                      selectedType = newSelection.first;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  )).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                  leading: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(Duration(days: 1)),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final expense = Expense(
                  name: nameController.text,
                  amount: double.parse(amountController.text),
                  date: selectedDate,
                  category: selectedCategory,
                  type: selectedType,
                );

                await DatabaseService.addExpense(expense);
                if (mounted) {
                  Navigator.pop(context);
                  _loadExpenses();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transaction added successfully')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('Export to PDF'),
              onTap: () async {
                Navigator.pop(context);
                await ExportService.generateAndPrintPDF(_expenses);
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart, color: Colors.blue),
              title: Text('Export to CSV'),
              onTap: () async {
                Navigator.pop(context);
                await ExportService.shareCSV(_expenses);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.green),
              title: Text('Share PDF'),
              onTap: () async {
                Navigator.pop(context);
                await ExportService.sharePDF(_expenses);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All History'),
        content: Text('Are you sure you want to delete all transactions? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseService.deleteAllExpenses();
              if (mounted) {
                Navigator.pop(context);
                _loadExpenses();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All transactions deleted')),
                );
              }
            },
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete "${expense.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseService.deleteExpense(expense.id);
              if (mounted) {
                Navigator.pop(context);
                _loadExpenses();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaction deleted')),
                );
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _showExportOptions,
            tooltip: 'Export Data',
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _showDeleteConfirmation,
            tooltip: 'Delete All History',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary Cards
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Income',
                          _totalIncome,
                          Colors.green,
                          Icons.arrow_upward,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Expense',
                          _totalExpense,
                          Colors.red,
                          Icons.arrow_downward,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Balance',
                          _totalIncome - _totalExpense,
                          Colors.blue,
                          Icons.account_balance_wallet,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(icon: Icon(Icons.list), text: 'History'),
                    Tab(icon: Icon(Icons.pie_chart), text: 'Charts'),
                    Tab(icon: Icon(Icons.bar_chart), text: 'Analytics'),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildHistoryTab(),
                      _buildChartsTab(),
                      _buildAnalyticsTab(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'all', label: Text('All')),
                    ButtonSegment(value: 'income', label: Text('Income')),
                    ButtonSegment(value: 'expense', label: Text('Expense')),
                  ],
                  selected: {_selectedFilter},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedFilter = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredExpenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No transactions yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first transaction',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = _filteredExpenses[index];
                    return Dismissible(
                      key: Key(expense.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteExpense(expense),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: expense.type == 'income'
                                ? Colors.green[100]
                                : Colors.red[100],
                            child: Icon(
                              expense.type == 'income'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: expense.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(expense.name),
                          subtitle: Text(
                            '${expense.category} • ${DateFormat('yyyy-MM-dd').format(expense.date)}',
                          ),
                          trailing: Text(
                            '${expense.type == 'income' ? '+' : '-'}\$${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: expense.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          onTap: () => _deleteExpense(expense),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ExpenseChart(expenses: _expenses, type: 'expense'),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Income Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ExpenseChart(expenses: _expenses, type: 'income'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 7 Days Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: BarChartWidget(expenses: _expenses),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildStatCard('Total Transactions', _expenses.length.toString()),
          _buildStatCard('Average Expense', 
              _expenses.where((e) => e.type == 'expense').isEmpty
                  ? '\$0.00'
                  : '\$${(_expenses.where((e) => e.type == 'expense').fold(0.0, (sum, item) => sum + item.amount) / 
                      _expenses.where((e) => e.type == 'expense').length).toStringAsFixed(2)}'),
          _buildStatCard('Highest Expense', 
              _expenses.where((e) => e.type == 'expense').isEmpty
                  ? '\$0.00'
                  : '\$${_expenses.where((e) => e.type == 'expense').map((e) => e.amount).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
