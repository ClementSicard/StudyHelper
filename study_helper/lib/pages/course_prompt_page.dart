import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';

class CoursePromptPage extends StatefulWidget {
  CoursePromptPage({Key key}) : super(key: key);

  @override
  _CoursePromptPageState createState() => _CoursePromptPageState();
}

class _CoursePromptPageState extends State<CoursePromptPage> {
  TextEditingController _nameController;
  TextEditingController _commentController;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _commentController = TextEditingController();
  }

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                'Welcome back to StudyHelper !',
                textAlign: TextAlign.center,
                style: customTextStyle(
                  size: 30,
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name of the course',
                    focusColor: Colors.red,
                    labelStyle: customTextStyle(),
                    fillColor: Colors.red,
                  ),
                  maxLengthEnforced: true,
                  maxLength: 100,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    labelStyle: customTextStyle(),
                    fillColor: Colors.red,
                  ),
                  maxLength: 1000,
                  maxLengthEnforced: true,
                  style: customTextStyle(),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(16.0))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
