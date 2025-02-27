import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class PdfService {
  static Future<String> generateInvoice(String customer, String date, List<List<String>> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Customer: $customer"),
            pw.Text("Date: $date"),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['Item', 'Quantity', 'Price'],
                ...items, // Add dynamic items
              ],
            ),
          ],
        ),
      ),
    );

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final filePath = "${downloadsDir!.path}/invoice.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filePath);
    return filePath;
  }
}
