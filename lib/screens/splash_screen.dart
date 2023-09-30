import 'package:flutter/material.dart';
import 'dart:async';
import 'barCode_scan_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startsplashtimer() async {
    Timer(const Duration(seconds: 4), () =>
    {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ScanScreen()))
    });
  }

  @override
  void initState() {
    super.initState();
    startsplashtimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("lib/assets/images/Seca.png"),
          const SizedBox(height: 35,),
          Text(
            "Le stationnement simplifié, la vie amplifiée",
            style: GoogleFonts.roboto( // Use GoogleFonts to apply the font
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
