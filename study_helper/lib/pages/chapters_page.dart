import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/subject.dart';
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

  List<List<Subject>> subjectsByColumn() {
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

    List<List<Subject>> subjectsByCol = [];
    for (int i = 0; i < maxLength; i++) {
      List<Subject> subList = [];
      for (int j = 0; j < _chapters.length; j++) {
        subList.add(_chapters[j].subjects.length > i
            ? _chapters[j].subjects[i]
            : Subject(""));
      }

      subjectsByCol.add(subList);
    }
    return subjectsByCol;
  }

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<CoursesDataHandler>(context, listen: true);
    _chapters = coursesData.getChapters(_course);
    // _chapters = [
    //   Chapter(
    //     "Analyse IV",
    //     subjects: [
    //       Subject("Fonctions"),
    //       Subject("Zebi"),
    //       Subject("Ok1"),
    //       Subject("Cauchy"),
    //       Subject("Dior"),
    //       Subject("asdsads"),
    //       Subject("hieori"),
    //       Subject("sss"),
    //     ],
    //   ),
    //   Chapter(
    //     "Covid 19",
    //     subjects: [
    //       Subject("sss"),
    //       Subject("Zebi"),
    //       Subject("Ok1"),
    //       Subject("Fonctions"),
    //       Subject("Cauchy"),
    //       Subject("sss"),
    //       Subject("Dior"),
    //       Subject("hieori"),
    //       Subject("sss"),
    //       Subject("asdsads"),
    //       Subject("asdsd"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qeweqws"),
    //       Subject("qweqew"),
    //     ],
    //   ),
    //   Chapter(
    //     "Mange moi le poireau",
    //     subjects: [
    //       Subject("zizon"),
    //       Subject("ses"),
    //       Subject("Osdsg"),
    //       Subject("Casdady"),
    //     ],
    //   ),
    // ];

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
        backgroundColor: Colors.white,
      ),
      body: _body(),
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          onPressed: _promptNewSubject,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget _body() {
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
                  onPressed: _promptNewChapter,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      List<List<Subject>> subjectsByCol = subjectsByColumn();
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _chapters
                  .map(
                    (c) => DataColumn(
                      label: Text(
                        c.name,
                        style: customTextStyle(),
                      ),
                      numeric: false,
                    ),
                  )
                  .toList()
                    ..add(
                      DataColumn(
                        label: IconButton(
                          icon: Icon(CupertinoIcons.add),
                          color: Colors.red,
                          onPressed: _promptNewChapter,
                        ),
                      ),
                    ),
              rows: subjectsByCol
                  .map(
                    (r) => DataRow(
                      cells: r
                          .map(
                            (s) => DataCell(
                              Text(
                                s.name,
                                style: customTextStyle(size: 20),
                              ),
                              showEditIcon: s.name != "",
                            ),
                          )
                          .toList()
                            ..add(
                              DataCell(
                                Text(""),
                              ),
                            ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    }
  }

  Future<Widget> _promptNewSubject() async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: Text(
            'Add a new subject',
            style: customTextStyle(),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autocorrect: false,
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Input the name"),
              ),
              SizedBox(height: 30),
              Text(
                "Select the chapter",
                style: customTextStyle(size: 20),
              ),
              SizedBox(height: 30),
              FloatingActionButton.extended(
                backgroundColor: Colors.red[200],
                label: Text(
                  "Pick chapter",
                  style: customTextStyle(
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => showCupertinoModalPopup(
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
                              print(_selectedChapter.name);
                              final coursesData =
                                  Provider.of<CoursesDataHandler>(context,
                                      listen: false);
                              await coursesData.addSubject(
                                _course,
                                _selectedChapter,
                                Subject(_textFieldController.text),
                              );
                              Navigator.of(context).pop();
                              Navigator.pop(context);
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
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                _selectedChapter = null;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () async {
                String inputName = _textFieldController.text;
                if (_selectedChapter.subjects
                    .map((c) => c.name)
                    .toSet()
                    .contains(inputName)) {
                  return AlertDialog(
                    elevation: 0,
                    title: Text(
                        'There already exists a subject with the same name in the same chapter'),
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
                    Subject(inputName),
                  );
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  Future<Widget> _promptNewChapter() async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: Text(
            'Add a new chapter',
            style: customTextStyle(),
          ),
          content: TextField(
            autocorrect: false,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Input the name"),
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
                if (_course.getChapters
                    .map((c) => c.name)
                    .toSet()
                    .contains(inputName)) {
                  return AlertDialog(
                    elevation: 0,
                    title: Text(
                        'There already exists a chapter with the same name'),
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
                  await coursesData.addChapter(_course, Chapter(inputName));
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
