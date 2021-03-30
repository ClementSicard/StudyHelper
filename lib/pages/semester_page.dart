import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/pages/semester_prompt_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';

class CoursesPage extends StatefulWidget {
  final Semester _semester;

  CoursesPage(this._semester, {Key key}) : super(key: key);

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget _body2(bool darkTheme) {
    final coursesProvider =
        Provider.of<CoursesDataHandler>(context, listen: true);
    return FutureBuilder(
      future: coursesProvider.getSemesters(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.isEmpty) {
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
                        "Add your first semester!",
                        style: customTextStyle(darkTheme),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height / 17.0,
                        backgroundColor: Colors.orange,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: darkTheme
                                ? const Color(0xff282728)
                                : Colors.white,
                          ),
                          enableFeedback: true,
                          iconSize: MediaQuery.of(context).size.height / 17.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SemesterPromptPage(),
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
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Semester current = snapshot.data[index];
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
                                  return FutureBuilder(
                                    future:
                                        coursesProvider.removeSemester(current),
                                    builder: (newContext, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        return TextButton(
                                          child: const Text("Done!"),
                                          onPressed: () =>
                                              Navigator.of(newContext).pop(),
                                        );
                                      } else {
                                        return Center(
                                          child:
                                              const CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
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
                                    builder: (context) => CoursesPage(current),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  });
            }
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
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
      ),
      body: _body2(themeChange.darkTheme),
      floatingActionButton: Visibility(
        visible: _semesters?.isNotEmpty ?? true,
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.white54,
          ),
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SemesterPromptPage()),
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
