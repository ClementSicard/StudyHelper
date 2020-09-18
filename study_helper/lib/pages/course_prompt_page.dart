import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/utils/custom_alert_dialog.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class CoursePromptPage extends StatefulWidget {
  factory CoursePromptPage({Key key}) {
    return CoursePromptPage._(key: key);
  }

  CoursePromptPage._({Key key}) : super(key: key);

  @override
  _CoursePromptPageState createState() => _CoursePromptPageState();
}

class _CoursePromptPageState extends State<CoursePromptPage> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
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
                  autocorrect: false,
                  controller: _nameController,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Name of the course',
                    focusColor: Colors.blueAccent,
                    labelStyle: customTextStyle(),
                    fillColor: Colors.blueAccent,
                  ),
                  maxLengthEnforced: true,
                  maxLength: 100,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: customTextStyle(),
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
                  controller: _descriptionController,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Description (optional)',
                    labelStyle: customTextStyle(),
                    fillColor: Colors.blueAccent,
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
            final coursesData =
                Provider.of<CoursesDataHandler>(context, listen: false);
            List<Course> courses = coursesData.courses;
            String givenName = _nameController.text;
            String description = _descriptionController.text;
            if (givenName == "") {
              await showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    title: Text("Please give a name for your course"),
                    message: Text("The name cannot be empty"),
                    actions: [
                      CupertinoActionSheetAction(
                        child: Text(
                          "Try again",
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (courses.map((c) => c.name).toSet().contains(givenName)) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomAlertDialog.alertdialog(
                    title: "You already have a course of with the name \"" +
                        givenName +
                        "\"",
                    content: "Please choose another name",
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
            } else {
              Course newCourse = Course(
                givenName,
                description: description,
              );
              final coursesData =
                  Provider.of<CoursesDataHandler>(context, listen: false);
              bool success = await coursesData.save(newCourse);
              print("bien joué maggle");
              if (!success) {
                Fluttertoast.showToast(
                  msg:
                      "The course couldn't be saved on your device: Please try later",
                  backgroundColor: Colors.blueAccent,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 20.0,
                  timeInSecForIosWeb: 1,
                );
              } else {
                Fluttertoast.showToast(
                  msg: givenName + " was successfully saved!",
                  backgroundColor: Colors.blueAccent,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 20.0,
                  timeInSecForIosWeb: 1,
                );
              }
              Navigator.of(context).pop();
            }
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
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
      ),
    );
  }
}
