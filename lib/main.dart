import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/auth.dart';
import 'package:freshgrownweb/pages/providers.dart';
import 'package:freshgrownweb/services/authservive.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        builder: (BuildContext context, Widget widget) {
          print('stream rebuild');
          return Wrapper();
        });
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user == null) {
      return MaterialApp(home: SignIn());
    } else {
      return ProviderWidget();
    }
    // return FutureBuilder(
    // future: Provider.of<Future<dynamic>>(context),
    // builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    // if (snapshot.connectionState == ConnectionState.waiting) {
    //   print("loading");
    //   return Container(
    //     color: Colors.blue,
    //     child: Center(child: Text('hi')),
    //   );
    // } else {
    //   if (snapshot.data == 'nouser') {
    //     print('nouser');
    //     return SignIn();
    //   }
    //   else if (snapshot.data == false) {
    //     print('not admin');
    //     return SignIn();
    //   } else if(snapshot.data == true) {
    //     print('is admin');
    //     return ProviderWidget();
    //   }
    //   else{
    //     print("wtf${snapshot.data}");
    //     return Container(
    //     color: Colors.blue,
    //     child: Center(child: Text('hi')),
    //   );
    //   }
    // }
    // }
    // user!=null?ProviderWidget():SignIn();
    // );
  }
}
