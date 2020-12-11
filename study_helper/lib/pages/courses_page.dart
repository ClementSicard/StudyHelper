import 'dart:convert';
import 'dart:io';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/pages/chapters_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'course_prompt_page.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage({Key key}) : super(key: key);

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget _body(List<Course> courses, bool darkTheme) {
    if (courses == null) {
      return Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              const Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      );
    } else if (courses.isEmpty) {
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
                "Add your first course!",
                style: customTextStyle(darkTheme),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 17.0,
                backgroundColor: Colors.orange,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: darkTheme ? Color(0xff282728) : Colors.white,
                  ),
                  enableFeedback: true,
                  iconSize: MediaQuery.of(context).size.height / 17.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursePromptPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      courses.sort((a, b) => a.name.compareTo(b.name));
      return Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 25.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            Course current = courses[index];
            return Column(
              children: [
                GestureDetector(
                  child: CupertinoContextMenu(
                    actions: [
                      CupertinoContextMenuAction(
                        child: const Text(
                          "Remove course",
                          textAlign: TextAlign.center,
                        ),
                        isDefaultAction: false,
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.delete,
                        onPressed: () async {
                          final coursesProvider =
                              Provider.of<CoursesDataHandler>(context,
                                  listen: false);
                          await coursesProvider.removeCourse(current);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    child: NiceButton(
                      darkTheme,
                      text: current.name,
                      color: Colors.blueAccent[100],
                      width: 500,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChaptersPage(current),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final coursesListProvider =
        Provider.of<CoursesDataHandler>(context, listen: true);
    List<Course> courses = coursesListProvider.courses;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your courses",
          textAlign: TextAlign.center,
          style: customTextStyle(themeChange.darkTheme),
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
          Padding(
            padding: EdgeInsets.only(
                right: 10.0 / 360.0 * MediaQuery.of(context).size.width),
            child: IconButton(
              icon: Icon(Icons.more_horiz_rounded),
              onPressed: () async {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext newContext) => CupertinoActionSheet(
                    title: const Text('Additional features'),
                    actions: [
                      CupertinoActionSheetAction(
                        child: const Text("Export to clipboard"),
                        isDefaultAction: false,
                        onPressed: () async {
                          final dir = await getApplicationDocumentsDirectory();
                          final File file =
                              File("${dir.path}/courses_data.shfile");
                          String contents;
                          if (await file.exists()) {
                            contents = await file.readAsString();
                          } else {
                            contents = "";
                          }
                          Clipboard.setData(ClipboardData(text: contents));
                          print("Done!");
                          Navigator.pop(newContext);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text("Import data from JSON file"),
                        isDefaultAction: false,
                        onPressed: () async {
                          Navigator.pop(newContext);
                          FilePickerCross file;

                          // Try opening file from explorer
                          try {
                            file = await FilePickerCross.importFromStorage();
                          } catch (e) {
                            // Handles the case where no file is selected
                            return Navigator.pop(newContext);
                          }
                          String content = file.toString();
                          print(content);
                          // Checks if correctly formated JSON file
                          try {
                            var json = jsonDecode(content);
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext aContext) =>
                                  CupertinoActionSheet(
                                title: const Text(
                                    "How do you want to import this JSON file ?"),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child:
                                        const Text("Merge with existing data"),
                                    onPressed: () {
                                      Navigator.pop(aContext);
                                      // TODO
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child:
                                        const Text("Overwrite existing data"),
                                    onPressed: () {
                                      Navigator.pop(aContext);
                                      final coursesProvider =
                                          Provider.of<CoursesDataHandler>(
                                              aContext,
                                              listen: false);
                                      try {
                                        coursesProvider.overwriteData(content);
                                        print("Done !");
                                      } catch (e) {
                                        return showCupertinoModalPopup(
                                          context: aContext,
                                          builder: (BuildContext bContext) =>
                                              CupertinoActionSheet(
                                            title: const Text(
                                                "Error importing this file"),
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              onPressed: () =>
                                                  Navigator.pop(bContext),
                                              child: const Text("Cancel"),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    isDestructiveAction: true,
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text("Cancel"),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          } catch (e) {
                            return showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext nContext) =>
                                  CupertinoActionSheet(
                                title: const Text(
                                    "The JSON file you selected is invalid"),
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text("Cancel"),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(nContext),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text("Export data to JSON file"),
                        isDefaultAction: false,
                        onPressed: () async {
                          final coursesProvider =
                              Provider.of<CoursesDataHandler>(context,
                                  listen: false);
                          print("Not done yet");
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
            ),
          ),
        ],
      ),
      body: _body(courses, themeChange.darkTheme),
      floatingActionButton: Visibility(
        visible: courses?.isNotEmpty ?? true,
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.white54,
          ),
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CoursePromptPage()),
            ),
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueAccent[100],
            elevation: 10,
          ),
        ),
      ),
    );
  }
}
