import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/home.dart';
import 'package:freshgrownweb/services/authservive.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderWidget extends StatelessWidget {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiProvider(
        providers: [
          StreamProvider<User>.value(value: authService.user),
        ],
        child: Home(),
      ),
    );
  }
}