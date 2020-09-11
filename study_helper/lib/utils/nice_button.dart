import 'package:flutter/material.dart';

import 'custom_text_styles.dart';

const LinearGradient defaultGradient = LinearGradient(
  colors: [
    Colors.yellow,
    Colors.orange,
  ],
);
// ignore: non_constant_identifier_names
Widget NiceButton({
  LinearGradient gradient = defaultGradient,
  Function onPressed,
  double borderRadius = 40.0,
  double height = 200.0,
  double width = 300.0,
  double elevation = 0,
  String text = "",
  Color textColor = Colors.white,
}) {
  return RaisedButton(
    onPressed: onPressed ?? () {},
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    color: Colors.orange,
    elevation: elevation,
    child: Ink(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        constraints: const BoxConstraints(
          minWidth: 88.0,
          minHeight: 36.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            text,
            style: customTextStyle(
              color: textColor,
            ),
          ),
        ),
        height: height,
        width: width,
      ),
    ),
  );
}
