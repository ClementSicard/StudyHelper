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
                body: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: semesters.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 40),
                    itemBuilder: (newContext, index) {
                      final Semester current = semesters[index];
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
                                  final TextEditingController
                                      _textFieldController =
                                      TextEditingController();
                                  await showDialog(
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
                                                        .updateSemesterDescription(
                                                            current,
                                                            _textFieldController
                                                                .text),
                                                decoration: InputDecoration(
                                                  hintText: "Edit description",
                                                  hintStyle: customTextStyle(
                                                      themeChange.darkTheme,
                                                      size: 17),
                                                ),
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                              ),
                                              const SizedBox(height: 40),
                                              // Theme(
                                              //   data:
                                              //       Theme.of(context).copyWith(
                                              //     highlightColor:
                                              //         Colors.transparent,
                                              //     splashColor: Colors.white54,
                                              //   ),
                                              //   child: FloatingActionButton(
                                              //     elevation: 0,
                                              //     backgroundColor:
                                              //         Colors.red[400],
                                              //     child: const Icon(
                                              //         Icons.save_sharp),
                                              //     heroTag: null,
                                              // onPressed: () async =>
                                              //     await dataProvider
                                              //         .updateSemesterDescription(
                                              //             current,
                                              //             _textFieldController
                                              //                 .text),
                                              //   ),
                                              // ),
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
                                                  .updateSemesterDescription(
                                                      current,
                                                      _textFieldController
                                                          .text);
                                              Navigator.of(context).pop();
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
                      );
                    },
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
