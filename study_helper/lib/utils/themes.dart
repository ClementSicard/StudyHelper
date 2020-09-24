import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? const Color(0xff121212) : Colors.white,
      backgroundColor: isDarkTheme ? const Color(0xff121212) : Colors.white,
      highlightColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
      hoverColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
      selectedRowColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
      splashColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
      secondaryHeaderColor: null,
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
            highlightColor: null,
            splashColor: null,
            disabledColor: null,
          ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkTheme ? const Color(0xff282728) : Colors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : Colors.black,
        size: 30,
      ),
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xff282728) : Colors.white,
      dividerColor: isDarkTheme ? const Color(0xff282728) : Colors.white,
    );
  }
}
