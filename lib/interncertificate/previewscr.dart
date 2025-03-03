import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String filePath;

  const PdfPreviewScreen({Key? key, required this.filePath}) : super(key: key);

void _savePdf(BuildContext context) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    Directory? downloadsDir = Directory("/storage/emulated/0/Download");
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final savedPath = "${downloadsDir!.path}/Interncertificate_${DateTime.now().millisecondsSinceEpoch}.pdf";
    File(filePath).copySync(savedPath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF saved at: $savedPath")));
    OpenFile.open(savedPath);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Preview"),
      actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _savePdf(context),
          ),
        ],),
      body: filePath.isNotEmpty
          ? PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: false,
            //  fitPolicy: FitPolicy.BOTH, // Adjusts to fit screen
              onRender: (_pages) {},
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
