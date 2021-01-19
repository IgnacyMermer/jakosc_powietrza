import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakosc_powietrza/MainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jakość powietrza',
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}