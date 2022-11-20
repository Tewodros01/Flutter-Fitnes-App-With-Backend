import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/home.dart';
import 'package:project/view/page/user/utils/user_preferences.dart';
import 'package:project/view/page/user/widget/profile_widget.dart';
import 'package:project/view/page/user/widget/textfield_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final user = UserPreferences.myUser;
  String? currentUser = "";
  String? email = "";
  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  _getUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    if (user != null) {
      setState(() {
        var userInfo = jsonDecode(user);
        currentUser = userInfo['name'];
        email = userInfo['email'];
      });
    } else {
      debugPrint("no info");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: user.imagePath!,
                  isEdit: true,
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  textString: 'name'.tr,
                  textController: textController,
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  textString: 'email'.tr,
                  textController: emailController,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    _updatedUserInfo();
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greenClr,
                    ),
                    child: const Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showMsg(msg) {
    Get.snackbar(
      "Update ",
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

  validatorUsername(val) {
    if (val.isEmpty) {
      return 'not_correct';
    } else {
      return "true";
    }
  }

  _updatedUserInfo() async {
    var userNameVal = validatorUsername(textController.text);
    var email = validateEmail(emailController.text);
    if (userNameVal == "not_correct") {
      _showMsg("Empty User name!");
    } else if (email == "invalide") {
      _showMsg("Please enter valid Email!");
    } else {
      try {
        var data = {
          'name': textController.text,
          'email': emailController.text,
        };

        var res = await CallApi().postData(data, 'update');
        var body = json.decode(res.body);
        print("${body}");
        if (body['success']) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('user', json.encode(body['user']));
          Get.to(() => const Home());
        } else if (body['success'] == false) {
          _showMsg(body["message"]);
        } else {
          var res = await CallApi().getData('refresh');
          var body = json.decode(res.body);
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('token', body['token']);
          _showMsg("Your session is referesh ");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
