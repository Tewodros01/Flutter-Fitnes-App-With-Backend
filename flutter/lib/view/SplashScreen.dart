import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/auth/auth_pages.dart';
import 'package:project/logic/services/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Center(
          child: SizedBox(
            width: 128,
            height: 128,
            child: Image.asset(
              "assets/images/logo_2.png",
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
