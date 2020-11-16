import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/addcategorypage.dart';
import 'package:freshgrownweb/pages/admin_details.dart';
import 'package:freshgrownweb/pages/addproduct.dart';
import 'package:freshgrownweb/pages/editMessages.dart';
import 'package:freshgrownweb/pages/editProduct.dart';
import 'package:freshgrownweb/pages/home.dart';
import 'package:freshgrownweb/pages/packages/editpackages.dart';
import 'package:freshgrownweb/pages/packages/packages.dart';

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
      case '/packages':
        return MaterialPageRoute(builder: (_) => Packages());
      case '/edit packages':
        return MaterialPageRoute(
            builder: (_) => EditPackage(package: settings.arguments));
      case '/edit messages':
        return MaterialPageRoute(builder: (_) => EditAdminMessages());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
