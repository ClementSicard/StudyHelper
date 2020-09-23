import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/pages/courses_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Ionicons.ios_school,
              color: Colors.orange,
              size: 40,
            ),
            SizedBox(width: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: customTextStyle(themeChange.darkTheme, size: 30),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeChange.darkTheme ? Icons.wb_sunny : Ionicons.ios_moon,
            ),
            onPressed: () {
              themeChange.darkTheme = !themeChange.darkTheme;
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              'Welcome back to StudyHelper !',
              textAlign: TextAlign.center,
              style: customTextStyle(
                themeChange.darkTheme,
                size: 30,
              ),
            ),
            SizedBox(height: 60),
            NiceButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursesPage()),
                );
              },
              text: "Continue studying",
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
