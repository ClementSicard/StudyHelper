import 'package:flutter/material.dart';

TextStyle customTextStyle(
  bool isDarkTheme, {
  double size = 25,
  Color color,
  FontWeight fw = FontWeight.w200,
}) {
  return TextStyle(
    fontSize: size,
    color: color ?? (isDarkTheme ? Colors.white : Colors.black),
    fontWeight: fw,
  );
}
