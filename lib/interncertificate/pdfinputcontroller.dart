import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_generator_1/interncertificate/pdfgenerator.dart';
import 'package:pdf_generator_1/interncertificate/previewscr.dart';


class UserInputController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  var selectedFromDate = Rxn<DateTime>();
  var selectedToDate = Rxn<DateTime>();
  var isLoading = false.obs;

  void pickFromDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedFromDate.value = pickedDate;
    }
  }

  void pickToDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedToDate.value = pickedDate;
    }
  }

  Future<void> generatePDF() async {
    if (nameController.text.isNotEmpty && selectedFromDate.value != null && selectedToDate.value != null) {
      isLoading.value = true; // Show loader

      await Future.delayed(Duration(milliseconds: 100)); // Allow UI update

      String formattedFromDate = DateFormat('dd.MM.yyyy').format(selectedFromDate.value!);
      String formattedToDate = DateFormat('dd.MM.yyyy').format(selectedToDate.value!);

      // Generate PDF
      String filePath = await PdfGenerator.generateCertificatePDF(
        nameController.text,
        formattedFromDate,
        formattedToDate,
      );

      isLoading.value = false; // Hide loader

      // Navigate to preview screen using GetX
      Get.to(() => PdfPreviewScreen(filePath: filePath));
    } else {
      Get.snackbar("Error", "Please enter name and select both dates",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
