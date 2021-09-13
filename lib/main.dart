import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Home/profile.dart';
import 'splashpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
