import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildstaticImageWidget(double size, String imagePath) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * 0.34),
      color: Colors.transparent,
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}

createCustomTextStyle(
    {Color color = Colors.black,
    double fontSize = 16,
    TextDecoration? textDecoration,
    FontWeight fontWeight = FontWeight.w600}) {
  return GoogleFonts.comfortaa(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: textDecoration,
    fontStyle: FontStyle.normal,
  );
}
