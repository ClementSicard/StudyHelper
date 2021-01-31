import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor:
          isDarkTheme ? const Color(0xff2D2225) : const Color(0xffF1E9EB),
      backgroundColor:
          isDarkTheme ? const Color(0xff2D2225) : const Color(0xffF1E9EB),
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
        color: isDarkTheme ? const Color(0xff2D2225) : const Color(0xffF1E9EB),
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
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xff2D2225) : const Color(0xffF1E9EB),
      dividerColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
    );
  }
}
