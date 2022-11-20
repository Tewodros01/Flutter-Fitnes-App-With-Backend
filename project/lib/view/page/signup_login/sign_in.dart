import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/home.dart';
import 'package:project/view/page/signup_login/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _showMsg(msg) {
    Get.snackbar(
      "Login ",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: greenClr,
    );
  }

  String validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'invalide';
    } else {
      return "true";
    }
  }

  validator(val, vale) {
    if (val.isEmpty || val.length < 6) {
      return 'not_correct';
    } else {
      return "true";
    }
  }

  _login() async {
    var data = {
      'email': emailController.text,
      'password': textController.text,
    };
    String vale = validateEmail(emailController.text);
    String valr = validator(textController.text, emailController);

    if (valr == "not_correct") {
      _showMsg("Email or Password Incorect!");
    } else if (vale == "invalide") {
      _showMsg("Email or Password Incorect!");
    } else {
      var res = await CallApi().postData(data, 'login');
      var body = json.decode(res.body);
      print("${body}");
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('user', json.encode(body['user']));
        Get.to(() => const Home());
        _showMsg("You are Successfuly log in");
      } else {
        _showMsg(body['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Material(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "stay".tr,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: Get.isDarkMode ? Colors.white : Colors.black54,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "helathy".tr,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: const Color(0XFF40D876),
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 140, left: 30, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.1),
                  TextInput(
                    textString: "email".tr,
                    textController: emailController,
                    hint: "email".tr,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  TextInput(
                    textString: "password".tr,
                    textController: textController,
                    hint: "password".tr,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          text: "sign_in".tr, fontSize: 22, isUnderLine: false),
                      GestureDetector(
                        onTap: () {
                          _login();
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenClr,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const SignUp());
                        },
                        child: TextWidget(
                          text: "sign_up".tr,
                          fontSize: 16,
                          isUnderLine: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextInput extends StatelessWidget {
  final String textString;
  TextEditingController textController;
  final String hint;
  bool obscureText;
  TextInput({
    super.key,
    required this.textString,
    required this.textController,
    this.hint = "",
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF9b9b9b),
      controller: textController,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: textString,
        hintStyle: const TextStyle(
          color: Color(0xFF9b9b9b),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
