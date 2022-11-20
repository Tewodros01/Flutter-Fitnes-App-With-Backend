import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/home.dart';
import 'package:project/view/page/user/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/view/page/signup_login/sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    _checkLoginStatus();
    super.initState();
  }

  _checkLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
      body: _isLoggedIn ? const Home() : const SignIn(),
    );
  }
}
