import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/mastered.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/pages/session_settings_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/diagonal_scrollview.dart';
import 'package:study_helper/utils/mastered_sliders.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'package:study_helper/utils/routes.dart';

class ChaptersGridPage extends StatefulWidget {
  final Course _course;
  ChaptersGridPage(this._course, {Key key}) : super(key: key);

  @override
  _ChaptersGridPageState createState() => _ChaptersGridPageState(_course);
}

class _ChaptersGridPageState extends State<ChaptersGridPage> {
  final Course _course;
  Chapter _selectedChapter;
  Mastered _mas = Mastered.Poorly;

  _ChaptersGridPageState(this._course);

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Provider.of<DarkThemeProvider>(context).darkTheme;
    final dataProvider = Provider.of<DataHandler>(context, listen: true);

    return FutureBuilder(
      future: dataProvider.getChaptersFromCourse(_course),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<Chapter> chapters = snapshot.data;

            if (chapters.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    _course.name,
                    textAlign: TextAlign.center,
                    style: customTextStyle(darkTheme),
                    maxLines: 2,
                  ),
                  actions: [
                    Visibility(
                      visible: _course.description != "",
                      child: IconButton(
                        icon: const Icon(MaterialCommunityIcons.information),
                        tooltip: "${_course.name} - Description",
                        onPressed: () async => await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              title: Text(
                                'Course description',
                                textAlign: TextAlign.center,
                                style: customTextStyle(darkTheme),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      _course.description,
                                      style:
                                          customTextStyle(darkTheme, size: 20),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              actionsPadding: const EdgeInsets.all(8.0),
                              actions: [
                                NiceButton(
                                  darkTheme,
                                  text: 'OK',
                                  textColor: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                  height: 60,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                body: Padding(
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
                        const SizedBox(height: 40),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height / 17.0,
                          backgroundColor: Colors.greenAccent,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: darkTheme
                                ? const Color(0xff282728)
                                : Colors.white,
                            enableFeedback: true,
                            iconSize: MediaQuery.of(context).size.height / 17.0,
                            onPressed: () =>
                                _promptNewChapter(dataProvider, darkTheme),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              List<List<MapEntry<Subject, Chapter>>> subjectsByCol =
                  subjectsByColumn(chapters);
              double dataRowHeight = 110;
              double headingRowHeight = 120;
              DataTable dataTable = DataTable(
                dataRowHeight: dataRowHeight,
                headingRowHeight: headingRowHeight,
                dividerThickness: 0.0,
                columnSpacing: 5.0,
                columns: chapters
                    .map(
                      (c) => DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            height: 90,
                            child: CupertinoContextMenu(
                              actions: [
                                CupertinoContextMenuAction(
                                    child: const Center(
                                      child: Text(
                                        "Mastery",
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    trailingIcon: Icons.star,
                                    isDefaultAction: false,
                                    isDestructiveAction: false,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ChapterMasteredSliderDialog(c));
                                    }),
                                CupertinoContextMenuAction(
                                  child: const Center(
                                    child: const Text(
                                      "Rename chapter",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  isDefaultAction: false,
                                  trailingIcon: CupertinoIcons.pencil,
                                  isDestructiveAction: false,
                                  onPressed: () async {
                                    final TextEditingController
                                        _textFieldController =
                                        TextEditingController();
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          elevation: 0,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(20.0),
                                            ),
                                          ),
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
                                                  controller:
                                                      _textFieldController,
                                                  onEditingComplete: () async =>
                                                      dataProvider.renameChapter(
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
                                                      TextCapitalization
                                                          .sentences,
                                                ),
                                                const SizedBox(height: 40),
                                                Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor: Colors.white54,
                                                  ),
                                                  child: FloatingActionButton
                                                      .extended(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.greenAccent,
                                                    icon: const Icon(
                                                        Icons.save_sharp),
                                                    label: Text(
                                                      "Save changes",
                                                      style: customTextStyle(
                                                        !darkTheme,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    heroTag: null,
                                                    onPressed: () => dataProvider
                                                        .renameChapter(
                                                            c,
                                                            _textFieldController
                                                                .text),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  color:
                                                      Colors.greenAccent[100],
                                                ),
                                              ),
                                              onPressed: () {
                                                _selectedChapter = null;
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                CupertinoContextMenuAction(
                                  child: const Center(
                                    child: const Text("Delete"),
                                  ),
                                  trailingIcon: CupertinoIcons.delete,
                                  isDefaultAction: false,
                                  isDestructiveAction: true,
                                  onPressed: () async {
                                    final dataProvider =
                                        Provider.of<DataHandler>(context,
                                            listen: false);
                                    await dataProvider.removeChapter(c);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                              child: FlatButton(
                                highlightColor: Colors.greenAccent[100],
                                splashColor: Colors.transparent,
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
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
                                onPressed: () =>
                                    _promptNewChapter(dataProvider, darkTheme),
                                mini: true,
                                elevation: 0,
                                heroTag: null,
                                focusElevation: 0,
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
                                    child: Container(
                                      width: 200,
                                      height: 90,
                                      child: CupertinoContextMenu(
                                        previewBuilder:
                                            (context, animation, child) {
                                          return FittedBox(
                                            fit: BoxFit.cover,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      64.0 * animation.value),
                                              child: child,
                                            ),
                                          );
                                        },
                                        actions: [
                                          CupertinoContextMenuAction(
                                            child: const Center(
                                              child: const Text(
                                                "Mastery",
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            trailingIcon: Icons.star,
                                            isDefaultAction: false,
                                            isDestructiveAction: false,
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              await showDialog(
                                                context: context,
                                                builder: (newContext) {
                                                  return SubjectMasteredSliderDialog(
                                                      s.key);
                                                },
                                              );
                                            },
                                          ),
                                          CupertinoContextMenuAction(
                                            child: const Center(
                                              child: const Text(
                                                "Rename subject",
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            trailingIcon: CupertinoIcons.pencil,
                                            isDefaultAction: false,
                                            isDestructiveAction: false,
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              TextEditingController
                                                  _textFieldController =
                                                  TextEditingController();
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    elevation: 0,
                                                    scrollable: true,
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
                                                      padding:
                                                          const EdgeInsets.all(
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
                                                            onEditingComplete: () async =>
                                                                await dataProvider
                                                                    .renameSubject(
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
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              splashColor:
                                                                  Colors
                                                                      .white54,
                                                            ),
                                                            child:
                                                                FloatingActionButton
                                                                    .extended(
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .greenAccent,
                                                              icon: Icon(Icons
                                                                  .save_sharp),
                                                              label: Text(
                                                                "Save changes",
                                                                style:
                                                                    customTextStyle(
                                                                  !darkTheme,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              heroTag: null,
                                                              onPressed: () async =>
                                                                  await dataProvider
                                                                      .renameSubject(
                                                                          s.key,
                                                                          _textFieldController
                                                                              .text),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          'CANCEL',
                                                          style: TextStyle(
                                                            color: Colors
                                                                    .greenAccent[
                                                                100],
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _selectedChapter =
                                                              null;
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
                                          CupertinoContextMenuAction(
                                            child: const Center(
                                              child: const Text("Delete"),
                                            ),
                                            isDefaultAction: false,
                                            trailingIcon: CupertinoIcons.delete,
                                            isDestructiveAction: true,
                                            onPressed: () async {
                                              final dataProvider =
                                                  Provider.of<DataHandler>(
                                                      context,
                                                      listen: false);
                                              await dataProvider
                                                  .removeSubject(s.key);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                        child: FlatButton(
                                          highlightColor: Colors.redAccent,
                                          color: Colors.redAccent[100],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                          ),
                                          onPressed: () {},
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    _course.name,
                    textAlign: TextAlign.center,
                    style: customTextStyle(darkTheme),
                    maxLines: 2,
                  ),
                  actions: [
                    Visibility(
                      visible: _course.description != "",
                      child: IconButton(
                        icon: const Icon(MaterialCommunityIcons.information),
                        tooltip: "${_course.name} - Description",
                        onPressed: () async => await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              title: Text(
                                'Course description',
                                textAlign: TextAlign.center,
                                style: customTextStyle(darkTheme),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(_course.description,
                                        style: customTextStyle(darkTheme,
                                            size: 20)),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              actionsPadding: const EdgeInsets.all(8.0),
                              actions: [
                                NiceButton(
                                  darkTheme,
                                  text: 'OK',
                                  textColor: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                  height: 60,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              10.0 / 360.0 * MediaQuery.of(context).size.width),
                      child: Hero(
                        tag: "animationToFullScreen",
                        child: Card(
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                            ),
                            color: Colors.greenAccent,
                            onPressed: () async {
                              Set subjects = chapters
                                  .map((c) => c.subjects.isNotEmpty)
                                  .toSet();
                              if (!subjects.contains(true)) {
                                await showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoActionSheet(
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
                                await Navigator.push(
                                  context,
                                  createRoute(
                                    SessionSettingsPage(_course, chapters),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Visibility(
                  visible: chapters.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white54,
                      ),
                      child: FloatingActionButton(
                        elevation: 0,
                        autofocus: true,
                        onPressed: () => _promptNewSubject(
                            darkTheme: darkTheme, chapters: chapters),
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
                body: DiagonalScrollView(child: dataTable),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: const CircularProgressIndicator(),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  List<List<MapEntry<Subject, Chapter>>> subjectsByColumn(
      List<Chapter> chapters) {
    List<List<Subject>> subjectsByChapter =
        chapters.map((c) => c.subjects).toList();

    // Find max lengthÔ
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

      for (int j = 0; j < chapters.length; j++) {
        subList.add(
          chapters[j].subjects.length > i
              ? MapEntry(chapters[j].subjects[i], chapters[j])
              : MapEntry(
                  Subject(name: "", chapterID: ""),
                  Chapter(name: "", courseID: ""),
                ),
        );
      }

      subjectsByCol.add(subList);
    }
    return subjectsByCol;
  }

  Future<Widget> _promptNewChapter(
      DataHandler dataHandler, bool darkTheme) async {
    TextEditingController _textFieldController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
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
            onEditingComplete: () => dataHandler.addChapter(
              Chapter(name: _textFieldController.text, courseID: _course.id),
            ),
            autocorrect: false,
            autofocus: true,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Input the name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.redAccent[100]),
              ),
              onPressed: () {
                _selectedChapter = null;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.greenAccent),
              ),
              onPressed: () async {
                await dataHandler.addChapter(Chapter(
                    name: _textFieldController.text, courseID: _course.id));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Widget> _promptNewSubject({
    @required bool darkTheme,
    @required List<Chapter> chapters,
  }) async {
    TextEditingController _textFieldController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
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
                  onEditingComplete: () async => await _showChapterSelection(
                      _textFieldController.text, chapters),
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
                  child: NiceButton(
                    darkTheme,
                    text: 'Pick chapter',
                    textColor: Colors.black,
                    onPressed: () async => await _showChapterSelection(
                        _textFieldController.text, chapters),
                    height: 60,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.redAccent[100],
                ),
              ),
              onPressed: () {
                _selectedChapter = null;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChapterSelection(
      String subjectName, List<Chapter> chapters) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Pick chapter'),
        actions: chapters
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
                  final Set<String> names =
                      _selectedChapter.subjects.map((c) => c.name).toSet();
                  if (names.contains(subjectName)) {
                    return AlertDialog(
                      scrollable: true,
                      elevation: 0,
                      title: const Text(
                          'There already exists a subject with the same name in the same chapter'),
                      content: const Text("Please try a different one"),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  } else if (subjectName == "") {
                    return AlertDialog(
                      scrollable: true,
                      elevation: 0,
                      title: const Text("A subject cannot have an empty name"),
                      content: const Text("Please try a different one"),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  } else {
                    await Provider.of<DataHandler>(context, listen: false)
                        .addSubject(
                      Subject(
                        name: subjectName,
                        chapterID: _selectedChapter.id,
                      ),
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
          onPressed: () => Navigator.pop(context, 'Cancel'),
        ),
      ),
    );
  }
}
