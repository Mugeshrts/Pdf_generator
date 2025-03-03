import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pdf_generator_1/interncertificate/pdfinputui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Certificate Generator",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserInputScreen(), // Set initial screen
    );
  }
}

