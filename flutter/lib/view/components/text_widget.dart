import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/services/theme.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  int? fontSize;
  bool? isUnderLine;
  final Color? color;
  TextWidget({
    super.key,
    this.text,
    this.fontSize,
    this.isUnderLine = false,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 3, // space between underline and text
      ),
      child: Text(
        text!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize!.toDouble(),
          fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
          color: Get.isDarkMode ? color : Colors.black54,
        ),
      ),
    );
  }
}
