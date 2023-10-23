
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String mail;
  final String nom;
  final String prenom;
  final String tel;
  bool attended ;

  User({
    required this.userId,
    required this.mail,
    required this.nom,
    required this.prenom,
    required this.tel,
    this.attended = false,
  });

  factory User.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return User(
      userId: data?['Id'],
      mail: data?['Mail'],
      nom: data?['Nom'],
      prenom: data?['Prenom'],
      tel: data?['Tel'],
      attended: data?['attended']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "Id": userId,
      if (mail != null) "Mail": mail,
      if (nom != null) "Nom": nom,
      if (prenom != null) "Prenom": prenom,
      if (tel != null) "Tel": tel,
      if (attended != null) "attended": attended,
    };
  }

  Map<String, dynamic> toServer() {
    return {
      if (mail != null) "email": mail,
      if (nom != null) "lastName": nom,
      if (prenom != null) "firstName": prenom,
      if (tel != null) "phoneNumber": tel,
    };
  }

  String toJson() {
    return jsonEncode(toFirestore());
  }

  String writeToServer(){
    return jsonEncode(toServer());
  }
}