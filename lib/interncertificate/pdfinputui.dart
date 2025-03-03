import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf_generator_1/interncertificate/pdfinputcontroller.dart';

class UserInputScreen extends StatelessWidget {
  final UserInputController controller = Get.put(UserInputController()); // Initialize GetX controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            SizedBox(height: 16),

            // From Date Picker
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedFromDate.value == null
                          ? "From Date"
                          : "From: ${DateFormat('dd.MM.yyyy').format(controller.selectedFromDate.value!)}",
                    ),
                    ElevatedButton(
                      onPressed: () => controller.pickFromDate(context),
                      child: Text("Pick Date"),
                    ),
                  ],
                )),
            SizedBox(height: 10),

            // To Date Picker
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedToDate.value == null
                          ? "To Date"
                          : "To: ${DateFormat('dd.MM.yyyy').format(controller.selectedToDate.value!)}",
                    ),
                    ElevatedButton(
                      onPressed: () => controller.pickToDate(context),
                      child: Text("Pick Date"),
                    ),
                  ],
                )),
            SizedBox(height: 24),

            // Generate PDF Button with Loader
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.generatePDF,
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text("Generate & Preview PDF"),
                )),
          ],
        ),
      ),
    );
  }
}
