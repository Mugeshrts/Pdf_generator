import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:exif/exif.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;


class PdfGenerator {
  static Future<String> generateCertificatePDF(String userName, String formattedFromDate, String formattedToDate) async {
    final pdf = pw.Document();

    // Load the image from assets
     // Load background image
   final ByteData data = await rootBundle.load('assets/images/RTS Certificate template1.jpg');
    final Uint8List imageBytes = data.buffer.asUint8List();
     const double inch = 72.0;
     const double cm = inch / 2.54;

    // Fix image orientation (if needed)
    //Uint8List finalImageBytes = await fixImageOrientation(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(29.7 * cm, 21.0 * cm, marginAll: 2.0 * cm),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
            child: pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.fill, // Ensures the image fits without distortion
              ),
            ),
          ),
              pw.Center(
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      "This Certificate is Awarded to",
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                   // pw.Text("Awarded to", style: pw.TextStyle(fontSize: 16)),
                    pw.Text(
                      userName,
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
                    ),
                     pw.SizedBox(height: 10),
                    pw.Text("for His outstanding completion of the Internship Program at"),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "REAL TECH SYSTEMS",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.orange, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "From $formattedFromDate to $formattedToDate",
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.blueGrey),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "He is found to be Hard Working, Sincere and Diligent."
                       "We wish him all the best for future."
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the file
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/certificate.pdf");
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static void sharePDF(String filePath) {
    Share.shareXFiles([XFile(filePath)], text: "Here is your generated PDF.");
  }

  /// Fixes image orientation based on EXIF data
  static Future<Uint8List> fixImageOrientation(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    
   // Read EXIF metadata
    final Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);
    
     if (exifData.containsKey('Orientation')) {
    final IfdTag orientationTag = exifData['Orientation']!;
    final int orientation = int.tryParse(orientationTag.printable) ?? 1;

    switch (orientation) {
      case 3:
        image = img.copyRotate(image,angle:180); // Rotate 180°
        break;
      case 6:
        image = img.copyRotate(image,angle:90); // Rotate 90° CW
        break;
      case 8:
        image = img.copyRotate(image,angle:-90); // Rotate 90° CCW
        break;
    }
  }

  return Uint8List.fromList(img.encodeJpg(image));
}
}