import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> getAdminStats(User user) async {
    if (user != null) {
      final admins = await FirebaseFirestore.instance
          .collection("admin")
          .doc(user.uid)
          .get();
      if (admins.exists) {
        return true;
      } else {
        _auth.signOut();
        return false;
      }
    } else {
      return 'nouser';
    }
  }

  Future signInAdmin(String email, String password) async {
    UserCredential result;
    User user;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {
      print(e);
      _auth.signOut();
      return null;
    }

    // print(admins.get('isAdmin'));
    if (user != null) {
      return await getAdminStats(user);
    } else
      return null;
  }

  User getCurrentUser(){
   return  _auth.currentUser;
  }

  // Stream<Future<dynamic>> get user {
    Stream<User> get user {
      return _auth.authStateChanges();
    // return _auth.authStateChanges().map((user) {
      // print("stream returned  :$user");
      // return getAdminStats(user);
    // });
  }

  void signOut() {
    _auth.signOut();
  }
}
