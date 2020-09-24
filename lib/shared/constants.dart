import 'package:freshgrownweb/Localization/appLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color appBgColor = Colors.green[100];
Color appBarColor = Colors.greenAccent[700];

String getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context).getranslatedValue(key);
}

const searchInputDecoration = InputDecoration(
  prefix: SizedBox(
    height: 17,
    width: 20,
  ),
  suffixIcon: Icon(Icons.search),
  border: InputBorder.none,
);

const textInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

void myToast(String toastMessage) {
  Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0);
}
