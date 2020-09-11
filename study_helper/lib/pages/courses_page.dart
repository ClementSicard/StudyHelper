import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/pages/settings_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage({Key key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your courses",
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
      body: Center(
        child: Padding(padding: const EdgeInsets.all(10.0), child: ListView()),
      ),
    );
  }
}
