import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String id;
  String name;
  String password;
  String phoneNumber;
  String email;
  String homeType;

  CurrentUser.fromFirebase(User user) {
    id = user.uid;
    email = user.email;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "email": email,
    };
  }
}
