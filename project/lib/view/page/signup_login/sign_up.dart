import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:project/view/page/signup_login/sign_in.dart';
import 'package:project/view/page/signup_login/wellcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _showMsg(msg) {
    Get.snackbar(
      "Registration ",
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

  validator(val) {
    if (val.isEmpty || val.length < 6) {
      return 'Empty';
    } else if (val != repassController.text) {
      return 'notMatch';
    } else {
      return "true";
    }
  }

  _register() async {
    String vale = validateEmail(emailController.text);
    String valr = validator(passController.text);
    if (vale == "invalide") {
      _showMsg("Enter valide  email ");
    } else if (valr == "Empty") {
      _showMsg("Password cannot be empty and must be at least 6 chars!");
    } else if (valr == "notMatch") {
      _showMsg("Password Not Mach");
    } else if (vale == "invalide") {
      _showMsg("Enter valide  email ");
    } else {
      var data = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passController.text,
      };
      var res = await CallApi().postData(data, 'register');
      var body = json.decode(res.body);
      print("Response body ${body}");
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('user', json.encode(body['user']));
        // ignore: use_build_context_synchronously
        Get.to(() => const WellComeView());
        _showMsg("You are Successfuly registor");
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
              padding: const EdgeInsets.only(top: 10, left: 30, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  SizedBox(height: height * 0.1),
                  TextInput(
                    textString: "name".tr,
                    textController: nameController,
                    obscureText: false,
                  ),
                  SizedBox(height: height * .05),
                  TextInput(
                    textString: "email".tr,
                    textController: emailController,
                    obscureText: false,
                  ),
                  SizedBox(height: height * .05),
                  TextInput(
                    textString: "password".tr,
                    textController: passController,
                    obscureText: true,
                  ),
                  SizedBox(height: height * .05),
                  TextInput(
                    textString: "password".tr,
                    textController: repassController,
                    obscureText: true,
                  ),
                  SizedBox(height: height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          text: "sign_up".tr, fontSize: 22, isUnderLine: false),
                      GestureDetector(
                        onTap: () {
                          _register();
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenClr,
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 30),
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
                          Get.to(() => const SignIn());
                        },
                        child: TextWidget(
                          text: "sign_in".tr,
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
