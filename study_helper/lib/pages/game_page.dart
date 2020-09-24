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
  List<Subject> _subjects;
  List<Color> _colors;
  final bool _random;
  Subject _currentSubject;

  _GamePageState(this._course, this._chapters, this._random);

  @override
  void initState() {
    super.initState();

    // Set up the page
    _subjects = [];
    for (Chapter c in _chapters) {
      _subjects.addAll(c.subjects);
    }
    if (_random) {
      _subjects.shuffle();
    }
    _colors = List.from(Colors.accents);
    _currentSubject = _subjects.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor = (_colors..shuffle()).first;
    return Hero(
      tag: "animationToFullScreen",
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: randomColor,
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
        backgroundColor: randomColor,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 30),
            Text(_currentSubject.name, style: customTextStyle(false, size: 40)),
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
                        color: randomColor,
                        enableFeedback: true,
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xff272827),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        color: randomColor,
                        enableFeedback: true,
                        iconSize: 30,
                        onPressed: () {
                          setState(
                            () {
                              _subjects.remove(_currentSubject);
                              _currentSubject = _subjects.first;
                              Color oldColor = randomColor;
                              while (randomColor == oldColor) {
                                randomColor = (_colors..shuffle()).first;
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
        ),
      ),
    );
  }
}
