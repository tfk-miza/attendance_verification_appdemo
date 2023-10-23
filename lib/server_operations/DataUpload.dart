//ici vous trouvez les fonctions sur le serveur en utilisant le Rest API

import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class DataUpload {
  static const firebaseUrl = 'https://authentificationapp-e3dbd-default-rtdb.europe-west1.firebasedatabase.app/.json';
  static const serverUrl = 'https://192.168.100.55:8083/api/users/';

  Future<void> uploadDataToLocalServerFromForm(User user) async {
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
              'origin': 'http://localhost',
              'Content-Type': 'application/json'
            },
          ),
        );

        if (serverResponse.statusCode == 200) {
          if (kDebugMode) {
            print('Data uploaded to the server successfully.');
          }
        } else {
          if (kDebugMode) {
            print(
                'Failed to upload data to the server. Status code: ${serverResponse.statusCode}'
            );
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch data from Firebase. Status code: ${firebaseResponse.statusCode}'
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> uploadUserDataToServer() async {
    final dio = Dio(BaseOptions(validateStatus: (status) => true));

        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };

    final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    final databaseEvent = await usersRef.once();
    final Map<dynamic, dynamic>? userData = databaseEvent.snapshot.value as Map?;

    if (userData != null) {
      final Set<String> addedUsers = {};

      userData.forEach((userId, userDatasnap) async {
        if (!addedUsers.contains(userId)) {
          final user = User(
            userId: userId,
            mail: userDatasnap['Mail'],
            nom: userDatasnap['Nom'],
            prenom: userDatasnap['Prenom'],
            tel: userDatasnap['Tel'].toString(),
          );


          final serverResponse = await dio.post(
            serverUrl,
            data: user.toServer(), // You may need to adjust this based on your server's requirements
            options: Options(
              headers: {
                'origin': 'http://localhost',
                'Content-Type': 'application/json',
              },
            ),
          );

          if (serverResponse.statusCode == 200) {
            if (kDebugMode) {
              print('Data uploaded to the server successfully.');
              print(user.toServer());
            }
          } else {
            if (kDebugMode) {
              print(
                  'Failed to upload data to the server. Status code: ${serverResponse.statusCode}'
              );
              print(user.toServer());
            }
          }
        }
      });
    }
  }

  Future<void> deleteUserByPhoneNumber( int phoneNumber) async {
    final dio = Dio(BaseOptions(validateStatus: (status) => true));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };

    try {

      final requestData = {
        'phoneNumber': phoneNumber,
      };

      final response = await dio.delete(
        serverUrl,
        data: requestData, // Pass the phone number as request data
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User with phone number $phoneNumber deleted successfully.');
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete user. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<dynamic> getUserByPhoneNumber(int phoneNumber) async {
    final dio = Dio(BaseOptions(validateStatus: (status) => true));

        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };

    try {
      final queryParams = {
        'phoneNumber': phoneNumber,
      };

      final response = await dio.get(
        serverUrl,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final clientData = response.data;

        if (clientData is Map<String, dynamic>) {
          return clientData;
        } else if (clientData is List<dynamic>) {
          return clientData;
        } else {
          if (kDebugMode) {
            print('Unexpected data format');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch client data. Status code: ${response.statusCode}');
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
