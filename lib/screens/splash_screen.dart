import 'package:flutter/material.dart';
import 'dart:async';
import 'barCode_scan_screen.dart';

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
      color: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Image.asset("assets/images/Seca1.png"),
          const SizedBox(height: 35,),

          const Text("Bienvenue dans l'avenir du stationnement : Simple, Rapide, Automatisé!", style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.normal,
              fontFamily: 'Raleway'
          ),)
        ],
      ),
    );
  }
}
