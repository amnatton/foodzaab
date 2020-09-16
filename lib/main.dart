import 'package:flutter/material.dart';
import 'package:foodzaab/screens/home.dart';

//void main() {
//runApp(MyApp());
//}
main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'Food Zaab',
      home: Home(),
    );
  }
}
