import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class CoursePromptPage extends StatefulWidget {
  CoursePromptPage({Key key}) : super(key: key);

  @override
  _CoursePromptPageState createState() => _CoursePromptPageState();
}

class _CoursePromptPageState extends State<CoursePromptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add a new course",
          textAlign: TextAlign.center,
          style: customTextStyle(),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 30,
          ),
          tooltip: "Back",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }
}
