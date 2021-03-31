import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/pages/courses_page.dart';
import 'package:study_helper/pages/semester_prompt_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';

class SemestersPage extends StatefulWidget {
  SemestersPage({Key key}) : super(key: key);

  @override
  SemestersPageState createState() => SemestersPageState();
}

class SemestersPageState extends State<SemestersPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final dataProvider = Provider.of<DataHandler>(context, listen: true);
    return FutureBuilder(
      future: dataProvider.getSemesters(),
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
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final List<Semester> semesters = snapshot.data;
            if (semesters.isEmpty) {
              return Scaffold(
                appBar: AppBar(),
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
                          "Add your first semester!",
                          style: customTextStyle(themeChange.darkTheme),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height / 17.0,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: themeChange.darkTheme
                                  ? const Color(0xff282728)
                                  : Colors.white,
                            ),
                            enableFeedback: true,
                            iconSize: MediaQuery.of(context).size.height / 17.0,
                            onPressed: () async => await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SemesterPromptPage(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
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
                ),
                body: ListView.builder(
                  itemCount: semesters.length,
                  itemBuilder: (newContext, index) {
                    Semester current = semesters[index];
                    return Column(
                      children: [
                        GestureDetector(
                          child: CupertinoContextMenu(
                            actions: [
                              CupertinoContextMenuAction(
                                child: const Text(
                                  "Remove semester",
                                  textAlign: TextAlign.center,
                                ),
                                isDefaultAction: false,
                                isDestructiveAction: true,
                                trailingIcon: CupertinoIcons.delete,
                                onPressed: () async {
                                  await dataProvider.removeSemester(current);
                                  Navigator.pop(newContext);
                                },
                              ),
                            ],
                            child: NiceButton(
                              themeChange.darkTheme,
                              text: current.name,
                              color: Colors.red[400],
                              width: 500,
                              onPressed: () async =>
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CoursesPage(current),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
                floatingActionButton: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white54,
                  ),
                  child: FloatingActionButton(
                    onPressed: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SemesterPromptPage()),
                    ),
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.red[400],
                    elevation: 0,
                  ),
                ),
              );
            }
          }
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
