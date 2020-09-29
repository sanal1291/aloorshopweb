import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/addcategorypage.dart';
import 'package:freshgrownweb/pages/admin_details.dart';
import 'package:freshgrownweb/pages/addproduct.dart';
import 'package:freshgrownweb/pages/editProduct.dart';
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
        return MaterialPageRoute(builder: (_) => AdminDetailsPage());
      case '/add category':
        return MaterialPageRoute(builder: (_) => AddCategoryPage());
      case '/edit items':
        return MaterialPageRoute(builder: (_) => EditItem());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
