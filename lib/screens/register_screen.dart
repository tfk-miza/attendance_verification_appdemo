import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:attendance_verification_appdemo/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:attendance_verification_appdemo/server_operations/DataUpload.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final Uuid uuid = const Uuid();
  final DataUpload dataUpload = DataUpload();

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final userId = uuid.v4();
      final newUser = User(
        userId: userId,
        mail: mailController.text,
        nom: nomController.text,
        prenom: prenomController.text,
        tel: telController.text,
      );

      storeUserData(newUser);
      sendEmail(
        name: newUser.nom,
        email: newUser.mail,
        message: "Hello, world",
      );

      dataUpload.uploadDataToLocalServerFromForm(newUser);

      clearFormFields();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully!'),
        ),
      );
    }
  }

  void clearFormFields() {
    mailController.clear();
    nomController.clear();
    prenomController.clear();
    telController.clear();
  }

  void storeUserData(User user) {
    final userRef = database.ref().child('users').child(user.userId);

    final userData = {
      'Mail': user.mail,
      'Nom': user.nom,
      'Prenom': user.prenom,
      'Tel': user.tel,
      'attended': true,
    };

    userRef.set(userData).then((_) {
      if (kDebugMode) {
        print('User data added with ID: ${user.userId}');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error adding user data: $error');
      }
    });
  }

  Future sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    const serviceId = 'service_kpqwsps';
    const templateId = 'template_5744d0s';
    const userId = 'IANonE2Vf6_yPpF5s';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'content-type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': name,
          'to_mail': email,
          'message': message,
        },
      }),
    );
    if (kDebugMode) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'User Registration',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: mailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: prenomController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: telController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                  onPressed: submitForm,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
