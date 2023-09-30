import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendEmail(String email) async {
  String username = 'seca.contacts@gmail.com';
  String password = 'seca123456789';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Seca Smart Parking')
    ..recipients.add(email)
    ..subject = 'Test Dart Mailer'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Seca</h1>\n<p>Smart parking</p>";

  try {
    final sendReport = await send(message, smtpServer);
    if (kDebugMode) {
      print('Message sent: $sendReport');
    }
  } on MailerException catch (e) {
    if (kDebugMode) {
      print('Message not sent.');
    }
    for (var p in e.problems) {
      if (kDebugMode) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}