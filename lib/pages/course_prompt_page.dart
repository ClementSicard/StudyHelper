import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/utils/custom_alert_dialog.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class CoursePromptPage extends StatefulWidget {
  final Semester _semester;

  CoursePromptPage(this._semester, {Key key}) : super(key: key);

  @override
  _CoursePromptPageState createState() => _CoursePromptPageState(_semester);
}

class _CoursePromptPageState extends State<CoursePromptPage> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  Semester _semester;

  _CoursePromptPageState(this._semester);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new course",
          textAlign: TextAlign.center,
          style: customTextStyle(themeChange.darkTheme),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
          ),
          tooltip: "Back",
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                controller: _nameController,
                autofocus: true,
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent[100]),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.greenAccent),
                  ),
                  labelText: 'Name of the course',
                  focusColor: Colors.blueAccent,
                  labelStyle: customTextStyle(themeChange.darkTheme),
                  fillColor: Colors.blueAccent,
                ),
                maxLength: 100,
                maxLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: customTextStyle(themeChange.darkTheme),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.greenAccent),
                  ),
                  labelText: 'Description (optional)',
                  labelStyle: customTextStyle(themeChange.darkTheme),
                  fillColor: Colors.blueAccent[100],
                ),
                maxLength: 1000,
                keyboardType: TextInputType.multiline,
                style: customTextStyle(themeChange.darkTheme, size: 20),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.white54,
          ),
          child: FloatingActionButton.extended(
            onPressed: () async {
              List<Course> courses = _semester.courses;
              final String givenName = _nameController.text;
              final String description = _descriptionController.text;
              if (givenName == "") {
                await showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      title: const Text("Please give a name for your course"),
                      message: const Text("The name cannot be empty"),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text(
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
              } else if (courses
                  .map((c) => c.name)
                  .toSet()
                  .contains(givenName)) {
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
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                final Course newCourse = Course(
                  name: givenName,
                  description: description,
                  semesterID: _semester.id,
                );
                final coursesData =
                    Provider.of<DataHandler>(context, listen: false);
                await coursesData.addCourse(newCourse);
                Navigator.pop(context);
              }
            },
            label: Text(
              'Save this course',
              style: customTextStyle(!themeChange.darkTheme),
            ),
            icon: const Icon(
              CupertinoIcons.check_mark,
              size: 50,
            ),
            backgroundColor: Colors.blueAccent[100],
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
