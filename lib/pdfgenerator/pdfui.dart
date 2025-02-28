import 'package:flutter/material.dart';
import 'package:pdf_generator_1/pdfgenerator/pdfgenerator.dart';
import 'package:pdf_generator_1/pdfgenerator/pdfpreview.dart';
import 'package:permission_handler/permission_handler.dart';


class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController kmsController = TextEditingController();
  final List<List<String>> items = [];

   void _showPreview() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please add at least one item!")));
      return;
    }

    String pdfPath = await PdfService.generateInvoice(
      customerController.text,
      dateController.text,
      mobileController.text,
      brandController.text,
      modelController.text,
      vehicleController.text,
      kmsController.text,
      items,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFPreviewScreen(pdfPath: pdfPath),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Invoice PDF",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Customer Name", customerController),
            _buildTextField("Mobile", mobileController, keyboardType: TextInputType.phone),
            _buildTextField("Date", dateController, keyboardType: TextInputType.datetime),
            _buildTextField("Brand Name", brandController),
            _buildTextField("Model", modelController),
            _buildTextField("Vehicle No", vehicleController),
            _buildTextField("Kms", kmsController, keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _addItemDialog(context),
              icon: Icon(Icons.add,color: Colors.white,),
              label: Text("Add Item",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.8, // Makes the button dynamic
              // child: ElevatedButton(
              //   onPressed: () => _generatePdf(),
              //   child: Text("Generate PDF", style: TextStyle(fontSize: 16,color: Colors.white)),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //     padding: EdgeInsets.symmetric(vertical: 12),
              //   ),
              // ),
              child: ElevatedButton(onPressed: _showPreview, child: Text("Preview Invoice")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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
          title: Text("Add Item",style: TextStyle(color: Colors.black),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Item Name", itemController),
              _buildTextField("Quantity", quantityController, keyboardType: TextInputType.number),
              _buildTextField("Amount", priceController, keyboardType: TextInputType.number),
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
              child: Text("Add",style: TextStyle(color: Colors.black),),
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
    String mobile = mobileController.text;
    String brand = brandController.text;
    String model = modelController.text;
    String vehicle = vehicleController.text;
    String kms = kmsController.text;

    String pdfPath = await PdfService.generateInvoice(
      customer, date, mobile, brand, model, vehicle, kms, items,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved at: $pdfPath")),
    );
  }
}