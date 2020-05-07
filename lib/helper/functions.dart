import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static saveUserLoggedinDetails({bool isLoggedIn}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool> getUserLoggedInDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(userLoggedInKey);
  }
}
