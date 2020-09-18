import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/pages/courses_page.dart';
import 'package:study_helper/pages/settings_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: customTextStyle(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.gear,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
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
