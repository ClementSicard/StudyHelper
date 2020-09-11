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
        Colors.blue[200],
        Colors.blue,
      ],
    ),
    LinearGradient(
      colors: [
        Colors.green[200],
        Colors.green,
      ],
    ),
    LinearGradient(
      colors: [
        Colors.red[200],
        Colors.red,
      ],
    ),
    LinearGradient(
      colors: [
        Colors.brown[200],
        Colors.brown,
      ],
    ),
  ];

  static LinearGradient randomGradient() {
    return (_gradients..shuffle()).first;
  }
}
