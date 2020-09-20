import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Color.fromRGBO(0x57, 0xb8, 0x46, .1),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0)),
  );