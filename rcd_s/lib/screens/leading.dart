import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcd_s/domain/currentUser.dart';
import 'authorization.dart';
import 'devices.dart';

class Leading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CurrentUser user = Provider.of<CurrentUser>(context);
    //final bool isLoggined = user != null;
    final bool isLoggined = false;

    return isLoggined ? Devices() : Authorization();
  }
}
