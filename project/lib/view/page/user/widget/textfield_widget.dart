import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldWidget extends StatelessWidget {
  final String textString;
  TextEditingController textController;
  final String hint;
  TextFieldWidget({
    super.key,
    required this.textString,
    required this.textController,
    this.hint = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          cursorColor: const Color(0xFF9b9b9b),
          controller: textController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: textString,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF9b9b9b),
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
