import 'package:flutter/material.dart';
import 'screens/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return MaterialApp(
        title: 'RCD-S',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // адаптивность
        ),
        home: Scaffold(
          body: Leading(),
        ),
      );
    });
  }
}
