import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/helper/functions.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  getUId() async {
    return (await FirebaseAuth.instance.currentUser()).uid;
  }

  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetails().then((value) {
      setState(() {
        isLoggedIn = value;
      });
      if (isLoggedIn) {
        getUId().then((val) {
          if (val != null) {
            Future.delayed(
                Duration(seconds: 5),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => isLoggedIn ?? false
                        ? Home(
                            uid: val,
                          )
                        : SignIn())));
          }
        });
      } else {
        Future.delayed(
            Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignIn())));
      }
    });
  }

  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 225.0,
          width: 225.0,
          child: FlareActor("assets/flare_animation/Loading_White_Moon.flr",
              animation: "Alarm"),
        ),
      ),
    );
  }
}
