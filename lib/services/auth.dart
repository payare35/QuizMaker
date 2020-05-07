import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(user.uid) : null;
  }

  Future signinWithEmailAndPass(
      String email, String password, BuildContext context) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser).userId;
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                // height: 120.0,
                child: Text(
                  "Invalid Credentials\nPlease Try Again",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ));
    }
  }

  Future signupWithEmailAndPass(
      String email, String password, BuildContext context) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser).userId;
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                // height: 120.0,
                child: Text(
                  "This User With the\nSame Email Id\nAlready Exists",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ));
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
