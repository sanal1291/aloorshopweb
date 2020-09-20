import 'package:flutter/material.dart';
import 'package:freshgrownweb/models/category.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/pages/home.dart';
import 'package:freshgrownweb/services/authservive.dart';
import 'package:freshgrownweb/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProviderWidget extends StatelessWidget {
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiProvider(
        providers: [
          StreamProvider<List<Item>>.value(value: databaseService.getItems),
          StreamProvider<User>.value(value: authService.user),
          StreamProvider<List<Category>>.value(
              value: databaseService.getCategories)
        ],
        child: Home(),
      ),
    );
  }
}
