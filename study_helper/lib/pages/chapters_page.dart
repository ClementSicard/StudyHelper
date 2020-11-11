import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/pages/session_settings_page.dart';
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
  List<Chapter> _chapters;
  Chapter _selectedChapter;
  _ChaptersPageState(this._course);

  List<List<MapEntry<Subject, Chapter>>> subjectsByColumn() {
    List<List<Subject>> subjectsByChapter =
        _chapters.map((c) => c.subjects).toList();

    // Find max length
    int maxLength = 0, minLength = 4294967296;
    for (List<Subject> list in subjectsByChapter) {
      if (maxLength < list.length) {
        maxLength = list.length;
      }
      if (minLength > list.length) {
        minLength = list.length;
      }
    }

    List<List<MapEntry<Subject, Chapter>>> subjectsByCol = [];
    for (int i = 0; i < maxLength; i++) {
      List<MapEntry<Subject, Chapter>> subList = [];
      for (int j = 0; j < _chapters.length; j++) {
        subList.add(_chapters[j].subjects.length > i
            ? MapEntry(_chapters[j].subjects[i], _chapters[j])
            : MapEntry(Subject(""), Chapter("")));
      }

      subjectsByCol.add(subList);
    }
    return subjectsByCol;
  }

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<CoursesDataHandler>(context, listen: true);
    _chapters = coursesData.getChapters(_course);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    AppBar appBar = AppBar(
      title: Text(
        _course.name,
        textAlign: TextAlign.center,
        style: customTextStyle(themeChange.darkTheme),
        maxLines: 2,
      ),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
        ),
        tooltip: "Back",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Visibility(
          visible: _chapters?.isNotEmpty ?? true,
          child: Hero(
            tag: "animationToFullScreen",
            child: Card(
              shape: CircleBorder(),
              child: IconButton(
                icon: Icon(Icons.play_arrow_rounded),
                color: Colors.greenAccent,
                onPressed: () {
                  Set subjects =
                      _chapters.map((c) => c.subjects.isNotEmpty).toSet();
                  if (!subjects.contains(true)) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text("Oops..."),
                        message: const Text(
                            "You must have at least one added subject to start a session"),
                        cancelButton: CupertinoActionSheetAction(
                          child: const Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionSettingsPage(_course, _chapters),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: _body(themeChange.darkTheme, appBar.preferredSize.height),
      floatingActionButton: Visibility(
        visible: _chapters?.isNotEmpty ?? true,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.white54,
            ),
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () => _promptNewSubject(themeChange.darkTheme),
              child: const Icon(
                Icons.add,
                size: 35,
              ),
              backgroundColor: Colors.redAccent[100],
              heroTag: null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(bool darkTheme, double appBarSize) {
    if (_chapters.isEmpty) {
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
                style: customTextStyle(darkTheme),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 17.0,
                backgroundColor: Colors.greenAccent,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: darkTheme ? Color(0xff282728) : Colors.white,
                  enableFeedback: true,
                  iconSize: MediaQuery.of(context).size.height / 17.0,
                  onPressed: () => _promptNewChapter(darkTheme),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      List<List<MapEntry<Subject, Chapter>>> subjectsByCol = subjectsByColumn();
      double dataRowHeight = 110;
      double headingRowHeight = 120;
      DataTable dataTable = DataTable(
        dataRowHeight: dataRowHeight,
        headingRowHeight: headingRowHeight,
        dividerThickness: 0.0,
        columnSpacing: 5.0,
        columns: _chapters
            .map(
              (c) => DataColumn(
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onLongPress: () async {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: const Text('Rename or delete chapter'),
                          message: const Text("Select an action"),
                          actions: [
                            CupertinoActionSheetAction(
                              child: const Text(
                                "Rename",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              isDefaultAction: false,
                              isDestructiveAction: false,
                              onPressed: () async {
                                Navigator.pop(context);
                                TextEditingController _textFieldController =
                                    TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      title: Text(
                                        'Rename the chapter',
                                        style: customTextStyle(darkTheme),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              autocorrect: false,
                                              autofocus: true,
                                              controller: _textFieldController,
                                              onEditingComplete: () =>
                                                  _renameChapter(
                                                      c,
                                                      _textFieldController
                                                          .text),
                                              decoration: InputDecoration(
                                                hintText: "Input the name",
                                                hintStyle: customTextStyle(
                                                    darkTheme,
                                                    size: 17),
                                              ),
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                            ),
                                            SizedBox(height: 40),
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.white54,
                                              ),
                                              child:
                                                  FloatingActionButton.extended(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                icon: Icon(Icons.save_sharp),
                                                label: Text(
                                                  "Save changes",
                                                  style: customTextStyle(
                                                    !darkTheme,
                                                    size: 20,
                                                  ),
                                                ),
                                                heroTag: null,
                                                onPressed: () => _renameChapter(
                                                    c,
                                                    _textFieldController.text),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.greenAccent[100],
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectedChapter = null;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text("Delete"),
                              isDestructiveAction: true,
                              isDefaultAction: false,
                              onPressed: () async {
                                final coursesProvider =
                                    Provider.of<CoursesDataHandler>(context,
                                        listen: false);
                                await coursesProvider.removeChapter(_course, c);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              'Cancel',
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
                    child: Container(
                      width: 200,
                      height: 90,
                      child: FlatButton(
                        highlightColor: Colors.greenAccent[100],
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            c.name,
                            style: customTextStyle(
                              darkTheme,
                              color: Colors.black,
                              size: 20,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                numeric: false,
              ),
            )
            .toList()
              ..add(
                DataColumn(
                  label: SizedBox(
                    height: 45,
                    width: 45,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white54,
                      ),
                      child: FloatingActionButton(
                        child: const Icon(
                          CupertinoIcons.add,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.greenAccent,
                        onPressed: () => _promptNewChapter(darkTheme),
                        mini: true,
                        elevation: 0,
                        heroTag: null,
                        autofocus: true,
                      ),
                    ),
                  ),
                ),
              ),
        rows: subjectsByCol
            .map(
              (r) => DataRow(
                cells: r
                    .map(
                      (s) => DataCell(
                        Visibility(
                          visible: s.key.name != "",
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: () async {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoActionSheet(
                                    title: const Text('Edit subject'),
                                    message: const Text(
                                        "Are you sure to rename/delete this subject ?"),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: const Text(
                                          "Rename",
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                        isDefaultAction: false,
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          TextEditingController
                                              _textFieldController =
                                              TextEditingController();
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                title: Text(
                                                  'Rename the subject',
                                                  style: customTextStyle(
                                                      darkTheme),
                                                ),
                                                content: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        autocorrect: false,
                                                        autofocus: true,
                                                        controller:
                                                            _textFieldController,
                                                        onEditingComplete: () =>
                                                            _renameSubject(
                                                                s.value,
                                                                s.key,
                                                                _textFieldController
                                                                    .text),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Input the name",
                                                          hintStyle:
                                                              customTextStyle(
                                                                  darkTheme,
                                                                  size: 17),
                                                        ),
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                      ),
                                                      SizedBox(height: 40),
                                                      Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor:
                                                              Colors.white54,
                                                        ),
                                                        child:
                                                            FloatingActionButton
                                                                .extended(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent,
                                                          icon: Icon(
                                                              Icons.save_sharp),
                                                          label: Text(
                                                            "Save changes",
                                                            style:
                                                                customTextStyle(
                                                              !darkTheme,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          heroTag: null,
                                                          onPressed: () =>
                                                              _renameSubject(
                                                                  s.value,
                                                                  s.key,
                                                                  _textFieldController
                                                                      .text),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    child: Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .greenAccent[100],
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _selectedChapter = null;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: const Text("Delete"),
                                        isDefaultAction: false,
                                        onPressed: () async {
                                          final coursesProvider =
                                              Provider.of<CoursesDataHandler>(
                                                  context,
                                                  listen: false);
                                          await coursesProvider.removeSubject(
                                              _course, s.value, s.key);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: const Text(
                                        'Cancel',
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 200,
                                height: 90,
                                child: FlatButton(
                                  highlightColor: Colors.redAccent,
                                  color: Colors.redAccent[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  onPressed: () {},
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Text(
                                        s.key.name,
                                        style: customTextStyle(
                                          darkTheme,
                                          color: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          size: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()
                      ..add(
                        const DataCell(
                          const Text(""),
                        ),
                      ),
              ),
            )
            .toList(),
      );

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: scrollHeight(
                context, appBarSize, dataRowHeight, headingRowHeight),
            child: dataTable,
          ),
        ),
      );
    }
  }

  double scrollHeight(BuildContext context, double appBarHeight,
      double dataRowHeight, double headingRowHeight) {
    int maxSubjects = 0;
    for (Chapter c in _chapters) {
      if (c.subjects.length > maxSubjects) {
        maxSubjects = c.subjects.length;
      }
    }
    MediaQueryData query = MediaQuery.of(context);
    double bodyHeight = query.size.height - appBarHeight - query.padding.top;
    double tableHeight = maxSubjects * dataRowHeight + headingRowHeight;
    return max(bodyHeight, tableHeight);
  }

  Future<Widget> _promptNewSubject(bool darkTheme) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            'Add a new subject',
            style: customTextStyle(darkTheme),
          ),
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autocorrect: false,
                  autofocus: true,
                  onEditingComplete: () =>
                      _showChapterSelection(_textFieldController.text),
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "Input the name",
                    hintStyle: customTextStyle(darkTheme, size: 17),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 40),
                Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white54,
                  ),
                  child: FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Colors.redAccent[100],
                    label: Text(
                      "Pick chapter",
                      style: customTextStyle(
                        !darkTheme,
                        size: 20,
                      ),
                    ),
                    heroTag: null,
                    onPressed: () =>
                        _showChapterSelection(_textFieldController.text),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.redAccent[100],
                ),
              ),
              onPressed: () {
                _selectedChapter = null;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Widget> _promptNewChapter(bool darkTheme) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          elevation: 0,
          title: Text(
            'Add a new chapter',
            style: customTextStyle(darkTheme),
          ),
          content: TextField(
            onEditingComplete: () => _addNewChapter(_textFieldController.text),
            autocorrect: false,
            autofocus: true,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Input the name"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.redAccent[100]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                onPressed: () => _addNewChapter(_textFieldController.text))
          ],
        );
      },
    );
  }

  void _renameChapter(Chapter chapter, String newName) async {
    if (newName == chapter.name) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Oops...'),
          message:
              const Text("The input name is the same has the previous one."),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      );
    } else {
      final coursesProvider =
          Provider.of<CoursesDataHandler>(context, listen: false);
      await coursesProvider.renameChapter(_course, chapter, newName);
      Navigator.pop(context);
    }
  }

  void _renameSubject(Chapter chapter, Subject subject, String newName) async {
    if (newName == chapter.name) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Oops...'),
          message:
              const Text("The input name is the same has the previous one."),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      );
    } else {
      final coursesProvider =
          Provider.of<CoursesDataHandler>(context, listen: false);
      await coursesProvider.renameSubject(_course, chapter, subject, newName);
      Navigator.pop(context);
    }
  }

  void _addNewChapter(String name) async {
    if (_chapters.map((c) => c.name).toSet().contains(name)) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title:
              const Text('There already exists a chapter with the same name'),
          message: const Text("Please try a different one"),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            isDestructiveAction: true,
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      final coursesData =
          Provider.of<CoursesDataHandler>(context, listen: false);
      await coursesData.addChapter(_course, Chapter(name));
      Navigator.of(context).pop();
    }
  }

  void _showChapterSelection(String subjectName) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Pick chapter'),
        actions: _chapters
            .map(
              (c) => CupertinoActionSheetAction(
                child: Text(
                  c.name,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  setState(() {
                    _selectedChapter = c;
                  });
                  Set<String> names =
                      _selectedChapter.subjects.map((c) => c.name).toSet();
                  if (names.contains(subjectName)) {
                    return AlertDialog(
                      elevation: 0,
                      title: const Text(
                          'There already exists a subject with the same name in the same chapter'),
                      content: const Text("Please try a different one"),
                      actions: [
                        FlatButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  } else if (subjectName == "") {
                    return AlertDialog(
                      elevation: 0,
                      title: const Text("A subject cannot have an empty name"),
                      content: Text("Please try a different one"),
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
                    final coursesData =
                        Provider.of<CoursesDataHandler>(context, listen: false);
                    await coursesData.addSubject(
                      _course,
                      _selectedChapter,
                      Subject(subjectName),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }
}
