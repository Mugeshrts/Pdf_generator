import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String path;

  const PdfViewerScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice PDF")),
      body: PDFView(filePath: path),
    );
  }
}
