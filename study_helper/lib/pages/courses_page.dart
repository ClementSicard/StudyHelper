import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/pages/chapters_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'course_prompt_page.dart';

class CoursesPage extends StatefulWidget {
  CoursesPage({Key key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses_test = [
    Course("Analyse IV"),
    Course("Programmation orientée système"),
    Course("Probabilities & Statistics"),
    Course("Signals and Systems"),
    Course("Musical Improvisation, Invention and Creativity"),
  ]..sort((a, b) => a.name.compareTo(b.name));

  Widget _body(List<Course> courses) {
    if (courses == null) {
      return Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
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
                "Add your first course !",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoursePromptPage()),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              Course current = courses[index];
              return Column(
                children: [
                  NiceButton(
                    text: current.name,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChaptersPage(current)),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          style: customTextStyle(),
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
        actions: [
          Visibility(
            visible: courses.isNotEmpty,
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
                  MaterialPageRoute(
                    builder: (context) => CoursePromptPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _body(courses),
    );
  }
}
