import 'package:flutter/material.dart';

class CustomGradients {
  static List<LinearGradient> _gradients = [
    LinearGradient(
      colors: [
        Colors.yellow[700],
        Colors.orange,
      ],
    ),
    LinearGradient(
      colors: [
        Colors.blue[400],
        Colors.blue,
      ],
    ),
    LinearGradient(
      colors: [
        Colors.green[200],
        Colors.green[300],
      ],
    ),
    LinearGradient(
      colors: [
        Colors.green[200],
        Colors.green[300],
      ],
    ),
  ];

  static LinearGradient randomGradient() {
    return (_gradients..shuffle()).first;
  }
}
