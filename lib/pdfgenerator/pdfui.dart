import 'package:flutter/material.dart';
import 'package:pdf_generator_1/pdfgenerator/pdfgenerator.dart';
import 'package:permission_handler/permission_handler.dart';


class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<List<String>> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Invoice PDF")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: customerController,
              decoration: InputDecoration(labelText: "Customer Name"),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: "Date"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addItemDialog(context),
              child: Text("Add Item"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _generatePdf(),
              child: Text("Generate & Preview PDF"),
            ),
          ],
        ),
      ),
    );
  }

  void _addItemDialog(BuildContext context) {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: itemController, decoration: InputDecoration(labelText: "Item Name")),
              TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
              TextField(controller: priceController, decoration: InputDecoration(labelText: "Price")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  items.add([itemController.text, quantityController.text, priceController.text]);
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generatePdf() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    String customer = customerController.text;
    String date = dateController.text;

    String pdfPath = await PdfService.generateInvoice(customer, date, items);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved at: $pdfPath")),
    );
  }
}