import 'package:flutter/material.dart';

class SmsSentScreen extends StatelessWidget {
  const SmsSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('SMS Sent',style: TextStyle(color: Colors.black),),
      ),
      body: const Center(
        child: Text('An SMS has been sent. '
            'Please make sure to  enable SMS Permission in the App Settings in case no SMS was Sent',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}
