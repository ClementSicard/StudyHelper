import 'package:flutter/material.dart';

TextStyle customTextStyle({
  double size = 25,
  Color color = Colors.black,
  FontWeight fw = FontWeight.w300,
}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}
