import 'package:flutter/material.dart';

class CustomTextStyle extends TextStyle {
  CustomTextStyle(
      {double size = 14,
      Color color = Colors.black,
      FontWeight fw = FontWeight.w200}) {
    TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }
}
