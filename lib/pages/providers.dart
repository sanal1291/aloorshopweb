import 'package:flutter/material.dart';
import 'package:freshgrownweb/models/category.dart';
import 'package:freshgrownweb/models/indipendentItem.dart';
import 'package:freshgrownweb/models/item.dart';
import 'package:freshgrownweb/pages/home.dart';
import 'package:freshgrownweb/services/authservive.dart';
import 'package:freshgrownweb/services/database.dart';
import 'package:freshgrownweb/services/router.dart';
import 'package:provider/provider.dart';

class ProviderWidget extends StatelessWidget {
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Item>>.value(value: databaseService.getItems),
        StreamProvider<List<Category>>.value(
            value: databaseService.getCategories),
        StreamProvider<List<IndiItem>>.value(
            value: databaseService.getIndiItems)
      ],
      child: MaterialApp(
        initialRoute: '/packages',
        onGenerateRoute: MyRouter.generateRoute,
        home: Home(),
      ),
    );
  }
}
