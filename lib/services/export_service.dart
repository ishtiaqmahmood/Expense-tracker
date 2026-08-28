import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExportService {
  static Future<File> exportToCSV(List<Expense> expenses) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${directory.path}/expenses_$timestamp.csv';
    
    List<List<dynamic>> rows = [
      ['ID', 'Name', 'Amount', 'Date', 'Category', 'Type']
    ];
    
    for (var expense in expenses) {
      rows.add([
        expense.id,
        expense.name,
        expense.amount.toStringAsFixed(2),
        DateFormat('yyyy-MM-dd HH:mm').format(expense.date),
        expense.category,
        expense.type,
      ]);
    }
    
    String csv = const CsvToListConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csv);
    
    return file;
  }

  static Future<void> shareCSV(List<Expense> expenses) async {
    final file = await exportToCSV(expenses);
    
    final result = await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expense Report',
      text: 'Here is your expense report',
    );
    
    print('Share result: $result');
  }

  static Future<void> generateAndPrintPDF(List<Expense> expenses) async {
    final pdf = pw.Document();
    
    // Calculate totals
    double totalIncome = expenses
        .where((e) => e.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
    double totalExpense = expenses
        .where((e) => e.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Expense Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 20),
            
            // Summary Section
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Income:', style: pw.TextStyle(fontSize: 14)),
                      pw.Text('\$${totalIncome.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Expense:', style: pw.TextStyle(fontSize: 14)),
                      pw.Text('\$${totalExpense.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.red)),
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Net Balance:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text('\$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                          style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: totalIncome >= totalExpense ? PdfColors.green : PdfColors.red)),
                    ],
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            pw.Text('Transaction History', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            
            // Table Header
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                  ],
                ),
                ...expenses.map((expense) => pw.TableRow(
                  children: [
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(DateFormat('yyyy-MM-dd').format(expense.date))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.name)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.category)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.type)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: expense.type == 'income' ? PdfColors.green : PdfColors.red,
                      ),
                    )),
                  ],
                )),
              ],
            ),
          ];
        },
      ),
    );
    
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<File> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${directory.path}/expenses_$timestamp.pdf';
    
    double totalIncome = expenses
        .where((e) => e.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
    double totalExpense = expenses
        .where((e) => e.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Expense Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Income:'),
                      pw.Text('\$${totalIncome.toStringAsFixed(2)}',
                          style: pw.TextStyle(color: PdfColors.green)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Expense:'),
                      pw.Text('\$${totalExpense.toStringAsFixed(2)}',
                          style: pw.TextStyle(color: PdfColors.red)),
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Net Balance:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('\$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: totalIncome >= totalExpense ? PdfColors.green : PdfColors.red)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Transaction History', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                  ],
                ),
                ...expenses.map((expense) => pw.TableRow(
                  children: [
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(DateFormat('yyyy-MM-dd').format(expense.date))),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.name)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.category)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(expense.type)),
                    pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: expense.type == 'income' ? PdfColors.green : PdfColors.red,
                      ),
                    )),
                  ],
                )),
              ],
            ),
          ];
        },
      ),
    );
    
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> sharePDF(List<Expense> expenses) async {
    final file = await exportToPDF(expenses);
    
    final result = await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expense Report PDF',
      text: 'Here is your expense report in PDF format',
    );
    
    print('Share result: $result');
  }
}
