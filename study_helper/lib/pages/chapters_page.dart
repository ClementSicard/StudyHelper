import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class ChaptersPage extends StatefulWidget {
  final Course _course;

  factory ChaptersPage(Course course, {Key key}) {
    return ChaptersPage._(course, key: key);
  }

  ChaptersPage._(
    this._course, {
    Key key,
  }) : super(key: key);

  @override
  _ChaptersPageState createState() => _ChaptersPageState(_course);
}

class _ChaptersPageState extends State<ChaptersPage> {
  final Course _course;

  _ChaptersPageState(this._course);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _course.name,
          textAlign: TextAlign.center,
          style: customTextStyle(),
          maxLines: 2,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () async {
              TextEditingController _textFieldController =
                  TextEditingController();
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 0,
                    title: Text('Rename this course'),
                    content: TextField(
                      controller: _textFieldController,
                      decoration:
                          InputDecoration(hintText: "Input the new name"),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          String inputName = _textFieldController.text;
                          if (inputName == _course.name) {
                            return AlertDialog(
                              elevation: 0,
                              title: Text(
                                  'The new name is the same as the previous one !'),
                              content: Text("You must input a different name"),
                              actions: [
                                FlatButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          } else {
                            _course.name = inputName;
                            final coursesData = Provider.of<CoursesDataHandler>(
                                context,
                                listen: false);
                            coursesData
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    if (_course.getChapters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.0,
              ),
              Text(
                "Add a first chapter",
                style: customTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 17.0,
                backgroundColor: Colors.orange,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  enableFeedback: true,
                  iconSize: MediaQuery.of(context).size.height / 17.0,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
