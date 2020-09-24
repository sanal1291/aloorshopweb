import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/editproduct.dart';
import 'package:freshgrownweb/pages/home.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case '/add product':
        return MaterialPageRoute(builder: (_) => EditProducts());
        break;
      case '/admin details':
        return MaterialPageRoute(builder: (_) => EditProducts());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}