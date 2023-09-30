import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> uploadDataToLocalServer() async {
  // Step 1: Fetch data from Firebase Realtime Database
  const String firebaseUrl = 'https://authentificationapp-e3dbd-default-rtdb.europe-west1.firebasedatabase.app/';
  final response = await http.get(Uri.parse(firebaseUrl));

  if (response.statusCode == 200) {
    final dataFromFirebase = jsonDecode(response.body);

    // Step 2: Define the local server URL
    const String localServerUrl = 'https://192.168.100.55:8083/api/users/';

    // Step 3: Send data to the local server using a POST request
    final localServerResponse = await http.post(
      Uri.parse(localServerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dataFromFirebase),
    );

    if (localServerResponse.statusCode == 200) {
      if (kDebugMode) {
        print('Data uploaded to the local server successfully.');
      }
    } else {
      if (kDebugMode) {
        print('Failed to upload data to the local server.');
      }
    }
  } else {
    if (kDebugMode) {
      print('Failed to fetch data from Firebase.');
    }
  }
}
