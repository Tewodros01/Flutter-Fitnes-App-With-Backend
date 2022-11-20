import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTab extends StatelessWidget {
  bool? selectedTab;
  String? name;
  TextTab({super.key, required this.selectedTab, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selectedTab!
          ? BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                width: 1,
                color: const Color(0xFF40D876),
              ),
            )
          : BoxDecoration(
              color: Colors.grey[900],
            ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          name!,
          style: GoogleFonts.lato(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
