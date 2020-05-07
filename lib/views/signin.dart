import 'package:flutter/material.dart';
import 'package:quiz_maker/helper/functions.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/views/home.dart';
import 'package:quiz_maker/views/signup.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  String email, password;
  AuthService _authService = AuthService();
  bool isLoading = false;
  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await _authService
          .signinWithEmailAndPass(email, password, context)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value != null) {
          HelperFunctions.saveUserLoggedinDetails(isLoggedIn: true);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(uid: value.toString()),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7.5,
                      ),
                      CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.blue,
                        backgroundImage: NetworkImage(
                            "https://clipartart.com/images/3d-cartoon-animals-clipart-8.jpg"),
                      ),
                      SizedBox(height: 30.0),
                      // Spacer(),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Email Id is Required";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          email = value.toString();
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Password"),
                        obscureText: true,
                        onChanged: (value) {
                          password = value.toString();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password is Required";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: signIn,
                        child: blueButton(context, "Sign In"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an Account? ",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 80.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
