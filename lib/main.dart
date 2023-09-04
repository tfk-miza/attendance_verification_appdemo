

import 'package:attendance_verification_appdemo/screens/barCode_scan_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const VerifApp());
}
class VerifApp extends StatelessWidget {
  const VerifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Scanner",
      debugShowCheckedModeBanner: false,
      home: ScanScreen(),

    );
  }
}
