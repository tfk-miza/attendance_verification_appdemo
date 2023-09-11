import 'package:flutter/material.dart';

class Apphelper {
  static navigatetoscreen(BuildContext context, Widget screenname) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screenname));
  }
}
