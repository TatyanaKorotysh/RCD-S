import 'package:flutter/material.dart';
import 'package:rcd_s/screens/appLang.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/services/isConnect.dart';
import 'package:rcd_s/services/json.dart';

class Loading extends StatefulWidget {
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IsConnect.initConnectivity(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: JsonService.isAdminExist(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              //JsonService.deleteFiles();
              return Authorization();
            } else {
              JsonService.creatrFiles();
              return AppLang();
            }
          } else {
            return Image(
              image: AssetImage("assets/img/preloader.gif"),
              width: MediaQuery.of(context).size.width * 0.3,
            );
          }
        },
      ),
    );
  }
}
