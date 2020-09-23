import 'package:flutter/material.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/subject.dart';

class GamePage extends StatefulWidget {
  final Course _course;
  final List<Chapter> _chapters;

  factory GamePage(Course course, List<Chapter> chapters, {Key key}) {
    return GamePage._(course, chapters, key: key);
  }

  GamePage._(this._course, this._chapters, {Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(_course, _chapters);
}

class _GamePageState extends State<GamePage> {
  final Course _course;
  final List<Chapter> _chapters;
  List<Subject> _subjects;

  _GamePageState(this._course, this._chapters);

  @override
  void initState() {
    _subjects = [];
    for (Chapter c in _chapters) {
      _subjects.addAll(c.subjects);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "animationToFullScreen",
      child: Container(
        color: Colors.greenAccent,
        child: null,
      ),
    );
  }
}
