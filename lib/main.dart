import 'package:flutter/material.dart';
import 'menu.dart';

void main() {
  runApp(MaterialApp(
    themeMode: ThemeMode.system,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    home: MenuOptions(),
  ));
}
