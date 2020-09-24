import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class GamePage extends StatefulWidget {
  final Course _course;
  final List<Chapter> _chapters;
  final bool _random;

  factory GamePage(Course course, List<Chapter> chapters, bool random,
      {Key key}) {
    return GamePage._(course, chapters, random, key: key);
  }

  GamePage._(this._course, this._chapters, this._random, {Key key})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(_course, _chapters, _random);
}

class _GamePageState extends State<GamePage> {
  final Course _course;
  final List<Chapter> _chapters;
  List<MapEntry<Subject, Chapter>> _subjects;
  List<Color> _colors;
  final bool _random;
  MapEntry<Subject, Chapter> _currentSubject;
  Color _color;

  _GamePageState(this._course, this._chapters, this._random);

  @override
  void initState() {
    super.initState();

    // Set up the page
    _subjects = [];
    for (Chapter c in _chapters) {
      _subjects.addAll(c.subjects.map((s) => MapEntry(s, c)).toList());
    }
    if (_random) {
      _subjects.shuffle();
    }
    _colors = List.from(Colors.accents);
    _color = (_colors..shuffle()).first;
    _currentSubject = _subjects.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "animationToFullScreen",
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: _color,
          centerTitle: true,
          title: Text(
            _course.name,
            style: customTextStyle(false),
          ),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
            ),
            color: Colors.black,
            tooltip: "Back",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: _color,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (_subjects.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 30),
          Text("Well done!", style: customTextStyle(false, size: 40)),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 30,
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            title: const Text('Not implemeted yet!'),
                            message: const Text("Coming soon"),
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text(
                                "Return",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 30,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 30),
          Text(_currentSubject.key.name,
              style: customTextStyle(false, size: 40)),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 30,
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            title: const Text('Not implemeted yet!'),
                            message: const Text("Coming soon"),
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text(
                                "Return",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 30,
                      onPressed: () {
                        setState(
                          () {
                            _subjects.remove(_currentSubject);
                            if (_subjects.isEmpty) {
                              _color = Colors.lightGreenAccent;
                            } else {
                              _currentSubject = _subjects.first;
                              Color oldColor = _color;
                              while (_color == oldColor) {
                                _color = (_colors..shuffle()).first;
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
