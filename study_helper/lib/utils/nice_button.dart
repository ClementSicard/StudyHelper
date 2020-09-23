import 'package:flutter/material.dart';
import 'custom_text_styles.dart';

// ignore: non_constant_identifier_names
Widget NiceButton(
  bool darkTheme, {
  LinearGradient gradient,
  Function onPressed,
  double borderRadius = 60.0,
  double height = 200.0,
  double width = 300.0,
  double elevation = 0,
  String text = "",
  Color textColor,
  Color color = Colors.orange,
  Object heroTag,
}) {
  return Container(
    child: RaisedButton(
      onPressed: onPressed ?? () {},
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color,
      elevation: elevation,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(
          minWidth: 88.0,
          minHeight: 36.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: customTextStyle(
              false,
              color: textColor ?? (darkTheme ? Colors.black : Colors.white),
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
        height: height,
        width: width,
      ),
    ),
  );
}
