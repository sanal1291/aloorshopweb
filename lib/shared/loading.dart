import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freshgrownweb/shared/constants.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      child: Center(
        child: SpinKitThreeBounce(
          color: appBgColor,
          size: 50.0,
        ),
      ),
    );
  }
}
