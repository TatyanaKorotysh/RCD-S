import 'package:firebase_auth/firebase_auth.dart';
import 'package:rcd_s/domain/currentUser.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<CurrentUser> singIn(String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return CurrentUser.fromFirebase(user);
    } catch (e) {
      //возвращать не null, а выводить текст ошибки
      return null;
    }
  }

  Future<CurrentUser> signOut() async {
    await _fAuth.signOut();
    return null;
  }

  Stream<CurrentUser> get currentUser {
    return _fAuth.authStateChanges().map(
        (User user) => {user} != null ? CurrentUser.fromFirebase(user) : null);
  }
}
