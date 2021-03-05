import 'package:flutter/material.dart';
import 'authorization.dart';
import 'devices.dart';

class Leading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLoggined = false;

    return isLoggined ? Devices() : Authorization();
  }
}
