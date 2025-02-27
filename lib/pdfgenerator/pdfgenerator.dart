import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class PdfService {
  static Future<String> generateInvoice(
    String customer,
    String date,
    String mobile,
    String brand,
    String model,
    String vehicle,
    String kms,
    List<List<String>> items,
  ) async {
    final pdf = pw.Document();

    // Load the logo
    Uint8List? logoData;
    try {
      final ByteData bytes = await rootBundle.load('assets/images/Fifth Piston@3x.jpg');
      logoData = bytes.buffer.asUint8List();
    } catch (e) {
      print("Error loading logo: $e");
    }

    // Styles
    final headingStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blue,
    );

    final normalTextStyle = pw.TextStyle(fontSize: 15, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Invoice Title (Centered)
            pw.Center(child: pw.Text("INVOICE", style: headingStyle)),
            pw.Divider(thickness: 2, color: PdfColors.blue),
            pw.SizedBox(height: 10),

            // Customer Details (Left) & Logo (Right)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Customer Details (Left)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Customer: $customer", style: normalTextStyle),
                    pw.Text("Mobile: $mobile", style: normalTextStyle),
                    pw.Text("Date: $date", style: normalTextStyle),
                    pw.SizedBox(height: 5),
                    pw.Text("Brand: $brand", style: normalTextStyle),
                    pw.Text("Model: $model", style: normalTextStyle),
                    pw.Text("Vehicle No: $vehicle", style: normalTextStyle),
                    pw.Text("Kms: $kms", style: normalTextStyle),
                  ],
                ),

                // Logo (Right, if available)
                if (logoData != null)
                  pw.Image(
                    pw.MemoryImage(logoData),
                    width: 100,
                    height: 100,
                  ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Table for Items
            pw.Container(
              padding: pw.EdgeInsets.all(8),
              child: pw.Table.fromTextArray(
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue100,
                ),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                data: [
                  ['Item', 'Quantity', 'Price'],
                  ...items, // Add dynamic items
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Total Amount (with Rupee Symbol ₹)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total: ${_calculateTotal(items)}", // ₹ Symbol
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
              ),
            ),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text("Thank you for doing businedd with us",style: pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold))
            )
          ],
        ),
      ),
    );

    // Get the directory for saving PDF
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

  // Calculate total price
  static double _calculateTotal(List<List<String>> items) {
    double total = 0;
    for (var item in items) {
      total += double.tryParse(item[2]) ?? 0;
    }
    return total;
  }
}
