
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String mail;
  final String nom;
  final String prenom;
  final String tel;

  User({
    required this.userId,
    required this.mail,
    required this.nom,
    required this.prenom,
    required this.tel,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "Id": userId,
      if (mail != null) "Mail": mail,
      if (nom != null) "Nom": nom,
      if (prenom != null) "Prenom": prenom,
      if (tel != null) "Tel": tel,
    };
  }
}