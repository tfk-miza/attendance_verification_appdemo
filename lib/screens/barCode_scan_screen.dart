// import 'package:attendance_verification_appdemo/helpers/app_helper.dart';
// import 'package:attendance_verification_appdemo/screens/register_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//
// class ScanScreen extends StatefulWidget {
//   const ScanScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//   var getResult = 'Awaiting Result';
//   var attendeeslist = ["mazen", "nooman", "becem"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Check'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 scanBarCode();
//               },
//               child: const Text('Scan Bar Code'),
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Text(getResult),
//             const SizedBox(
//               height: 20.0,
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Loginscreen()));
//                 Apphelper.navigatetoscreen(context, const RegistrationScreen());
//               },
//               child: const Text(
//                   "Vous n'êtes pas inscris ? S'inscrire Maintenant",
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void scanBarCode() async {
//     try {
//       final barcode = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666',
//         'Cancel',
//         true,
//         ScanMode.BARCODE,
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         getResult = barcode;
//       });
//       if (attendeeslist.contains(getResult)) {
//         var name = getResult;
//         getResult = " $name Thanks for Checking in";
//       } else {
//         getResult = "You will be added to our Database Thank you for your Attendance ";
//         attendeeslist.add(getResult);
//       }
//     } on PlatformException {
//       getResult = 'Failed to scan Bar Code.';
//     }
//   }
// }
import 'package:attendance_verification_appdemo/helpers/app_helper.dart';
import 'package:attendance_verification_appdemo/screens/register_screen.dart';
import 'package:attendance_verification_appdemo/screens/sms_sent_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:attendance_verification_appdemo/server_operations/DataUpload.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  var getResult = '';
  String nom = '';
  String prenom = '';
  DataUpload dataUpload = DataUpload();

  @override
  void initState() {
    super.initState();

    // Call uploadDataToLocalServer when the screen is launched
    _uploadDataOnScreenLaunch();
  }

  // Function to upload data to the local server
  Future<void> _uploadDataOnScreenLaunch() async {
    try {
      // Call the uploadDataToLocalServer function from your DataUpload instance
      await dataUpload.uploadDataToLocalServer();

      // Rest of your code...
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading data on screen launch: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Attendance Check',style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              onPressed: () {
                scanBarCode();
              },
              child: const Text('Scan QR Code',style: TextStyle(color: Colors.black),),
            ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            // Text(getResult),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                Apphelper.navigatetoscreen(context, const RegistrationScreen());
              },
              child: const Text(
                "Vous n'êtes pas inscris ? S'inscrire Maintenant Cliquez Ici",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanBarCode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        getResult = barcode;
      });


      final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
          'users').child(getResult);

      usersRef.once().then((DatabaseEvent databaseEvent) async {
        if (databaseEvent.snapshot.value != null) {
          final userData = databaseEvent.snapshot.value as Map<dynamic,
              dynamic>;
          nom = userData['Nom'] as String;
          prenom = userData['Prenom'] as String;
          final recipientPhoneNumber = userData['Tel'] as String;

          final String message = '$prenom $nom merci d\'avoir atteint notre convention';
          final List<String> recipients = [recipientPhoneNumber];

          _sendSMS(message, recipients);
          if (kDebugMode) {
            print("$nom $prenom un sms a été envoyé");
          }

          Apphelper.navigatetoscreen(context, const SmsSentScreen());

          await usersRef.update({'attended': true});
          if (kDebugMode) {
            print('User attendance status updated to true');
          }


        } else {
          setState(() {
            if (kDebugMode) {
              print('User not found in the database.');
            }
          });
        }
      });
    } on PlatformException {
      setState(() {
        if (kDebugMode) {
          print('Failed to scan Bar Code.');
        }
      });
    }
  }


  void _sendSMS(String message, List<String> recipients) async {
    final String result = await sendSMS(
        message: message, recipients: recipients, sendDirect: true);

    if (kDebugMode) {
      print(result);
    }
  }



}
  // void sendSMS(String message, String recipientPhoneNumber) async {
  //   try {
  //     final String message = '$prenom $nom merci d\'avoir atteint notre convention';
  //
  //     final List<String> recipients = [recipientPhoneNumber];
  //
  //     String _result = await sendSMS(message, recipients)
  //         .catchError((onError) {
  //       print(onError);
  //     });
  //
  //     print(_result);
  //
  //     setState(() {
  //       getResult = 'Authentication SMS sent successfully.';
  //     });
  //   } catch (error) {
  //     setState(() {
  //       getResult = 'Error sending SMS: $error';
  //     });
  //   }
  // }}

