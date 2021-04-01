import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/pages/chapters_grid_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'package:study_helper/utils/routes.dart';
import '../utils/custom_text_styles.dart';
import 'course_prompt_page.dart';

class CoursesPage extends StatefulWidget {
  final Semester _semester;
  CoursesPage(this._semester, {Key key}) : super(key: key);

  @override
  CoursesPageState createState() => CoursesPageState(_semester);
}

class CoursesPageState extends State<CoursesPage> {
  final Semester _semester;
  bool vis;

  CoursesPageState(this._semester);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final dataProvider = Provider.of<DataHandler>(context, listen: true);

    return FutureBuilder(
      future: dataProvider.getCoursesFromSemester(_semester),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Your semesters",
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
                actions: [
                  Visibility(
                    visible: _semester.description != "",
                    child: IconButton(
                      icon: const Icon(MaterialCommunityIcons.information),
                      tooltip: "${_semester.name} - Description",
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
                              'Semester description',
                              textAlign: TextAlign.center,
                              style: customTextStyle(themeChange.darkTheme),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(_semester.description,
                                      style: customTextStyle(
                                          themeChange.darkTheme,
                                          size: 20)),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            actionsPadding: const EdgeInsets.all(8.0),
                            actions: [
                              NiceButton(
                                themeChange.darkTheme,
                                text: 'OK',
                                textColor: Colors.black,
                                onPressed: () => Navigator.of(context).pop(),
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
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final List<Course> courses = snapshot.data;
            if (courses.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "${_semester.name} - Courses",
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
                body: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(5.0),
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.0,
                    ),
                    Text(
                      "Add your first course!",
                      style: customTextStyle(themeChange.darkTheme),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height / 17.0,
                      backgroundColor: Colors.orange,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: themeChange.darkTheme
                              ? Color(0xff282728)
                              : Colors.white,
                        ),
                        enableFeedback: true,
                        iconSize: MediaQuery.of(context).size.height / 17.0,
                        onPressed: () async => await Navigator.push(
                          context,
                          createRoute(CoursePromptPage(_semester)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              courses.sort((a, b) => a.name.compareTo(b.name));

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "${_semester.name} - Courses",
                    style: customTextStyle(themeChange.darkTheme),
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      CupertinoIcons.back,
                    ),
                    tooltip: "Back",
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    Visibility(
                      visible: _semester.description != "",
                      child: IconButton(
                        icon: const Icon(MaterialCommunityIcons.information),
                        tooltip: "${_semester.name} - Description",
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
                                'Semester description',
                                textAlign: TextAlign.center,
                                style: customTextStyle(themeChange.darkTheme),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(_semester.description,
                                        style: customTextStyle(
                                            themeChange.darkTheme,
                                            size: 20)),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              actionsPadding: const EdgeInsets.all(8.0),
                              actions: [
                                NiceButton(
                                  themeChange.darkTheme,
                                  text: 'OK',
                                  textColor: Colors.black,
                                  onPressed: () => Navigator.of(context).pop(),
                                  height: 60,
                                  color: Colors.orangeAccent,
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
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35.0, top: 25.0),
                  child: Center(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 40),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final Course current = courses[index];
                        final String opDesc = current.description == ""
                            ? "Add a description"
                            : "Update description";
                        return Align(
                          child: GestureDetector(
                            child: CupertinoContextMenu(
                              actions: [
                                CupertinoContextMenuAction(
                                  child: Text(
                                    opDesc,
                                    textAlign: TextAlign.center,
                                  ),
                                  isDefaultAction: false,
                                  isDestructiveAction: false,
                                  trailingIcon: CupertinoIcons.pencil,
                                  onPressed: () async {
                                    Navigator.pop(context);
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
                                            opDesc,
                                            style: customTextStyle(
                                                themeChange.darkTheme),
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
                                                      await dataProvider
                                                          .updateCourseDescription(
                                                              current,
                                                              _textFieldController
                                                                  .text),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Edit description",
                                                    hintStyle: customTextStyle(
                                                        themeChange.darkTheme,
                                                        size: 17),
                                                  ),
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                ),
                                                const SizedBox(height: 40),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'SAVE',
                                                style: TextStyle(
                                                  color: Colors.lightGreen,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await dataProvider
                                                    .updateCourseDescription(
                                                        current,
                                                        _textFieldController
                                                            .text);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                  color: Colors.red[400],
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                CupertinoContextMenuAction(
                                  child: const Text(
                                    "Delete",
                                    textAlign: TextAlign.center,
                                  ),
                                  isDefaultAction: false,
                                  isDestructiveAction: true,
                                  trailingIcon: CupertinoIcons.delete,
                                  onPressed: () async {
                                    final dataProvider =
                                        Provider.of<DataHandler>(context,
                                            listen: false);
                                    await dataProvider.removeCourse(current);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              child: NiceButton(
                                themeChange.darkTheme,
                                text: current.name,
                                color: Colors.orange,
                                width: 500,
                                onPressed: () async =>
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChaptersGridPage(current)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                floatingActionButton: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white54,
                  ),
                  child: FloatingActionButton(
                    onPressed: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CoursePromptPage(_semester)),
                    ),
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.orange[400],
                    elevation: 0,
                  ),
                ),
              );
            }
          }
        } else
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: const CircularProgressIndicator(),
            ),
          );
      },
    );
  }
}
