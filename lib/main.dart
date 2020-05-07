import 'package:flutter/material.dart';
import 'package:quiz_maker/helper/functions.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signin.dart';
import 'package:quiz_maker/views/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    // checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetails().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: (isLoggedIn ?? false) ? Home() : SignIn(),
    );
  }
}
