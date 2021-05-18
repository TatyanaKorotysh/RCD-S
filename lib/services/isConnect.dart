import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rcd_s/screens/noConnect.dart';

class IsConnect {
  static final Connectivity _connectivity = Connectivity();

  static Future initConnectivity(BuildContext context) async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (result == ConnectivityResult.none) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NoConnect();
      }));
    }
  }
}
