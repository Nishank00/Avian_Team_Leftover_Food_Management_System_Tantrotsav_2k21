import 'package:flutter/material.dart';

import 'splashpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prasad - Letfover food management system',
      theme: ThemeData(
        fontFamily: "ProductSans",
      ),
      home: SplashPage(),
    );
  }
}
