import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Home/homepage.dart';
import 'Home/profile.dart';
import 'splashpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Prasad - Letfover food management system',
//       theme: ThemeData(
//         fontFamily: "ProductSans",
//       ),
//       home: SplashPage(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() {
    user = _auth.currentUser;
    print('user id : $user');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "ProductSans"),
      home: user != null ? HomePage() : SplashPage(),
    );
  }
}
