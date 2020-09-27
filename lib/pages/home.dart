import 'package:flutter/material.dart';
import 'package:freshgrownweb/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/add product');
                },
                child: Text('Add Product')),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/admin details');
                },
                child: Text('Miscellaneous')),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/add category');
                },
                child: Text('Add category')),
          ],
        ),
      ),
    );

    // return EditProducts();
  }
}
