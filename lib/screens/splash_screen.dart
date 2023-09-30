import 'package:flutter/material.dart';
import 'dart:async';
import 'barCode_scan_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

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
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Image.asset("lib/assets/images/Seca1.png"),
          const SizedBox(height: 35,),

          const Text("Le stationnement simplifié, la vie amplifiée", style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto'
          ),)
        ],
      ),
    );
  }
}
