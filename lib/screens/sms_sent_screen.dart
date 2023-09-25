import 'package:flutter/material.dart';

class SmsSentScreen extends StatelessWidget {
  const SmsSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Sent'),
      ),
      body: const Center(
        child: Text('An SMS has been sent.'),
      ),
    );
  }
}
