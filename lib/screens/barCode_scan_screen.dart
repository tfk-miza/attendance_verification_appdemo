import 'package:attendance_verification_appdemo/screens/register%20screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/widgets.dart';
import 'w';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  var getResult = 'Awaiting Result';
  var attendeeslist = ["mazen","nooman","becem"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Check'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  scanBarCode();
                },
                child: const Text('Scan Bar Code'),
              ),
              const SizedBox(height: 20.0,),
              Text(getResult),
            ],
          ),const SizedBox(height: 12,),
      TextButton(
          onPressed: (){
            // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Loginscreen()));
            Apphelper.navigatetoscreen(context, const RegistrationScreen());
          },
          child: const Text("Already have an Account ? Log in now.",style: TextStyle(color: Colors.white),)
      ),
      ),
    );
  }

  void scanBarCode() async {
    try{
      final barcode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (!mounted) return;

      setState(() {
        getResult = barcode;
      });
      if (attendeeslist.contains(getResult))
        print("$getResult Thanks for Checking in");

      else {
        print("You will be added to our Database Thank you for your Attendance ") ;
        attendeeslist.add(getResult);
      }

    } on PlatformException {
      getResult = 'Failed to scan Bar Code.';
    }

  }

}