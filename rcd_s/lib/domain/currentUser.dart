import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String id;

  CurrentUser.fromFirebase(User user) {
    id = user.uid;
  }
}
