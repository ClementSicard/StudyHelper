import 'package:flutter/material.dart';
import 'package:study_helper/objects/course.dart';

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
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(),
    );
  }
}
