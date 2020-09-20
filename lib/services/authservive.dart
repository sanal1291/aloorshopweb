import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future getAdminStats(User user) async{
    final admins = await
        FirebaseFirestore.instance.collection("admin").doc(user.uid).get();
        print(admins);
        if(admins.exists){
          return user;
        }
        else return null;
  }

  Future signInAdmin(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    // print(admins.get('isAdmin'));
    if (user != null) {
      print(user);
      return await getAdminStats(user);
    }
    else return null;
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }
}
