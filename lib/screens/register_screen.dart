import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import the Firebase Realtime Database package
import 'package:uuid/uuid.dart';
import 'package:attendance_verification_appdemo/models/user_model.dart'; // Import your User model

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

  final FirebaseDatabase database = FirebaseDatabase.instance; // Initialize the Firebase Realtime Database
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

                    // Store user data in the Firebase Realtime Database
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
    DatabaseReference userRef = database.ref().child('users').child(user.userId);

    // Convert the User object to a Map
    Map<String, dynamic> userData = {
      'Mail': user.mail,
      'Nom': user.nom,
      'Prenom': user.prenom,
      'Tel': user.tel,
    };

    // Add the user data to the Realtime Database
    userRef.set(userData).then((_) {
      print('User data added with ID: ${user.userId}');
    }).catchError((error) {
      print('Error adding user data: $error');
    });
  }
}
