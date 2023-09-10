

import 'package:attendance_verification_appdemo/screens/barCode_scan_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
