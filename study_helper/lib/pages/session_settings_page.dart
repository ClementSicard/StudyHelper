import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class SessionSettingsPage extends StatefulWidget {
  final Course _course;
  final List<Chapter> _chapters;

  factory SessionSettingsPage(Course course, List<Chapter> chapters,
      {Key key}) {
    return SessionSettingsPage._(course, chapters, key: key);
  }

  SessionSettingsPage._(this._course, this._chapters, {Key key})
      : super(key: key);

  @override
  _SessionSettingsPageState createState() =>
      _SessionSettingsPageState(_course, _chapters);
}

class _SessionSettingsPageState extends State<SessionSettingsPage> {
  final Course _course;
  final List<Chapter> _chapters;
  List<bool> _selected;
  bool _all = true;

  _SessionSettingsPageState(this._course, this._chapters);

  @override
  void initState() {
    _selected = _chapters.map((c) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tune your session",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          children: [
            SizedBox(height: 30),
            Text(
              "Select chapters",
              style: customTextStyle(),
            ),
            Visibility(child: ListTile()),
            SizedBox(height: 30),
          ]
            ..addAll([
              ListTile(
                title: Text(
                  "All",
                  style: customTextStyle(size: 20),
                ),
                trailing: CupertinoSwitch(
                  activeColor: Colors.red,
                  value: _all,
                  onChanged: (bool value) {
                    print(value);
                    setState(() {
                      print(value);
                      _all = value;
                      _selected = _chapters.map((c) => value).toList();
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _all = !_all;
                  });
                },
              ),
            ])
            ..addAll(_chapterSelection()),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
          onPressed: () {},
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

  List<Visibility> _chapterSelection() {
    List<Visibility> switchesTiles = [];
    for (int i = 0; i < _chapters.length; i++) {
      Chapter current = _chapters[i];
      switchesTiles.add(
        Visibility(
          visible: _all == false,
          child: ListTile(
            title: Text(
              current.name,
              style: customTextStyle(size: 20),
            ),
            trailing: CupertinoSwitch(
              value: _selected[i],
              onChanged: (bool value) {
                setState(() {
                  _selected[i] = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _selected[i] = !_selected[i];
                if (_selected.any((element) => false)) {
                  _all = false;
                } else if (!_selected.any((element) => false)) {
                  _all = true;
                }
              });
            },
          ),
        ),
      );
    }
    return switchesTiles;
  }
}
