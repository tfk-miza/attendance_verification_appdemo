import 'package:attendance_verification_appdemo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mailController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Padding(
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
                onPressed: () {

                  if (_formKey.currentState!.validate()) {

                    String userId = uuid.v4();


                    User newUser = User(
                      userId: userId,
                      mail: mailController.text,
                      nom: nomController.text,
                      prenom: prenomController.text,
                      tel: telController.text,
                    );

                    // Store user data in Firebase Firestore
                    storeUserData(newUser);


                    mailController.clear();
                    nomController.clear();
                    prenomController.clear();
                    telController.clear();


                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User registered successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void storeUserData(User user) {
    firestore.collection('Users').doc(user.userId).set({
      'mail': user.mail,
      'nom': user.nom,
      'prenom': user.prenom,
      'tel': user.tel,
    }).then((value) {
      print('User data added with ID: ${user.userId}');
    }).catchError((error) {
      print('Error adding user data: $error');
    });
  }
}

