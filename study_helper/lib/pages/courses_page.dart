import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Course> coursesTest = [
    Course("Analyse IV"),
    Course("Programmation orientée système"),
    Course("Probabilities & Statistics"),
    Course("Signals and Systems"),
    Course("Musical Improvisation, Invention and Creativity"),
  ]..sort((a, b) => a.name.compareTo(b.name));

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
                    color: Colors.white,
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
        padding: const EdgeInsets.all(25.0),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            Course current = courses[index];
            return Column(
              children: [
                GestureDetector(
                  child: NiceButton(
                    text: current.name,
                    color: Colors.blueAccent[100],
                    width: 500,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChaptersPage(current)),
                      );
                    },
                  ),
                  onLongPress: () async {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          title: const Text("Confirm delete"),
                          message:
                              const Text("Are you sure to delete this course?"),
                          actions: [
                            CupertinoActionSheetAction(
                              child: const Text("Delete"),
                              onPressed: () async {
                                final coursesProvider =
                                    Provider.of<CoursesDataHandler>(context,
                                        listen: false);
                                await coursesProvider.removeCourse(current);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 30),
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
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your courses",
          textAlign: TextAlign.center,
          style: customTextStyle(themeChange.darkTheme),
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
        actions: [
          Visibility(
            visible: courses?.isNotEmpty ?? true,
            child: IconButton(
              icon: Icon(
                CupertinoIcons.add_circled,
                color: Colors.black,
                size: 30,
              ),
              color: Colors.white,
              tooltip: "Add new course",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CoursePromptPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: _body(courses, themeChange.darkTheme),
      floatingActionButton: Visibility(
        visible: courses?.isNotEmpty ?? true,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CoursePromptPage()),
          ),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blueAccent[100],
          elevation: 0,
        ),
      ),
    );
  }
}
