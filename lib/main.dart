import 'package:flutter/widgets.dart';
import 'config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    theme: new ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    ),
    title: 'ELS',
    routes: APP_ROUTER
  ));
}
