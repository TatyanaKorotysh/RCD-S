import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rcd_s/domain/currentUser.dart';

class DatabaseService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future addOrUpateUser(CurrentUser user) async {
    return await _userCollection.doc(user.id).set(user.toMap());
  }
}
