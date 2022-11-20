import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/user/edit_profile.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Get.isDarkMode ? darkGreyClr : Colors.white;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = AssetImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.amberAccent,
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(
              width: 3,
              color: const Color(0xFF40D876),
            ),
            image: const DecorationImage(
              image: AssetImage(
                "assets/images/logo_2.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Get.to(() => const EditProfile());
            },
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: greenClr,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.edit : Icons.edit,
            color: greenClr,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
