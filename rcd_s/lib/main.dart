import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/leading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("Ошибка при подключении БД"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
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
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: Text("Загрузка..."),
        );
      },
    );
  }
}
