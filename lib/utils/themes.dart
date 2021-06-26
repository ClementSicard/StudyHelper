import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Styles {
  static const Color darkThemeBackground = const Color(0xFF121212);
  static const Color darkThemeForeground = const Color(0xFF242424);
  static const Color lightThemeBackground = Colors.white;
  static Color lightThemeForeground = Colors.grey[100];

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? darkThemeBackground : Colors.white,
      highlightColor: Colors.white24,
      hoverColor: Colors.transparent,
      splashColor: Colors.white24,
      accentColor: Colors.transparent,
      focusColor: Colors.transparent,
      disabledColor: Colors.grey,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            disabledColor: Colors.transparent,
          ),
      cardTheme: CardTheme(
          elevation: 0,
          color: isDarkTheme ? Colors.grey[850] : Colors.grey[100]),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkTheme ? Colors.black : Colors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        actionsIconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
          size: 30,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : Colors.black,
        size: 30,
      ),
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
      dividerColor: isDarkTheme ? Colors.black : Colors.white,
    );
  }
}
