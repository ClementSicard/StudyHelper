import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/utils/custom_alert_dialog.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class CoursePromptPage extends StatefulWidget {
  final List<Course> _courses;

  factory CoursePromptPage(List<Course> courses, {Key key}) {
    return CoursePromptPage._(courses, key: key);
  }

  CoursePromptPage._(this._courses, {Key key}) : super(key: key);

  @override
  _CoursePromptPageState createState() => _CoursePromptPageState(_courses);
}

class _CoursePromptPageState extends State<CoursePromptPage> {
  TextEditingController _nameController;
  TextEditingController _commentController;

  final List<Course> _courses;

  _CoursePromptPageState(this._courses);

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
        actions: [
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {}),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            children: <Widget>[
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
                  keyboardType: TextInputType.multiline,
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
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (_nameController.text == "") {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomAlertDialog.alertdialog(
                    title: "Please fill all the fields in",
                    content: "You cannot have empty fields",
                    actions: [
                      MapEntry(
                        "Try again",
                        () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {}
          },
          label: Text(
            'Save this course',
            style: customTextStyle(
              color: Colors.white,
            ),
          ),
          icon: const Icon(
            CupertinoIcons.check_mark,
            color: Colors.white,
            size: 50,
          ),
          backgroundColor: Colors.orange,
          elevation: 0,
        ),
      ),
    );
  }
}
