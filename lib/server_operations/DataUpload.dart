import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class DataUpload {
  Future<void> uploadDataToLocalServerFromForm(User user) async {
    const firebaseUrl = 'https://authentificationapp-e3dbd-default-rtdb.europe-west1.firebasedatabase.app/.json';
    const serverUrl = 'https://192.168.100.55:8083/api/users/';

    final dio = Dio(BaseOptions(validateStatus: (status) => true));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };

    try {
      final firebaseResponse = await dio.get(firebaseUrl);

      if (firebaseResponse.statusCode == 200) {
        final firebaseData = firebaseResponse.toString();

        final processedData = processData(firebaseData);
        processedData['id'] = user.userId;
        processedData['firstName'] = user.prenom;
        processedData['lastName'] = user.nom;
        processedData['phoneNumber'] = int.parse(user.tel);
        processedData['email'] = user.mail;

        final serverResponse = await dio.post(
          serverUrl,
          data: processedData,
          options: Options(
            headers: {
              'origin' : 'http://localhost',
              'Content-Type': 'application/json'},
          ),
        );

        if (serverResponse.statusCode == 200) {
          if (kDebugMode) {
            print('Data uploaded to the server successfully.');
          }
        } else {
          if (kDebugMode) {
            print(
              'Failed to upload data to the server. Status code: ${serverResponse
                  .statusCode}');
          }
        }
      } else {
        if (kDebugMode) {
          print(
            'Failed to fetch data from Firebase. Status code: ${firebaseResponse
                .statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Map<String, dynamic> processData(String firebaseData) {
    return json.decode(firebaseData);
  }
}