import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdf_generator_1/pdfgenerator/pdfui.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PdfScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Fifth Piston@3x.jpg"),
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(), // Loading indicator
        ),
      ),
    );
  }
}
