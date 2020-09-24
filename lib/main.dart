import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/auth.dart';
import 'package:freshgrownweb/pages/providers.dart';
import 'package:freshgrownweb/services/authservive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<User>>.value(
      value: AuthService().user,
      builder: (BuildContext context, Widget widget) {
        print('stream rebuild');
        print(Provider.of<Future<User>>(context));
        return MaterialApp(
          home: Scaffold(
            body: Wrapper(),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Future<User>>(context),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          // print(snapshot.data);
          if (snapshot.data != null) {
            return ProviderWidget();
          } else {
            return SignIn();
          }
        }
        // user!=null?ProviderWidget():SignIn();
        );
  }
}
