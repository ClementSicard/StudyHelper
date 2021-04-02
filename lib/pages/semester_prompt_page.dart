import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/utils/custom_alert_dialog.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class SemesterPromptPage extends StatefulWidget {
  factory SemesterPromptPage({Key key}) {
    return SemesterPromptPage._(key: key);
  }

  SemesterPromptPage._({Key key}) : super(key: key);

  @override
  _SemesterPromptPageState createState() => _SemesterPromptPageState();
}

class _SemesterPromptPageState extends State<SemesterPromptPage> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new semester",
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                controller: _nameController,
                autofocus: true,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent[100]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]),
                  ),
                  labelText: 'Name of the semester',
                  labelStyle: customTextStyle(themeChange.darkTheme),
                ),
                maxLength: 100,
                maxLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: customTextStyle(themeChange.darkTheme),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent[100]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]),
                  ),
                  labelText: 'Description (optional)',
                  labelStyle: customTextStyle(themeChange.darkTheme),
                  fillColor: Colors.blueAccent[100],
                ),
                maxLength: 1000,
                keyboardType: TextInputType.multiline,
                style: customTextStyle(themeChange.darkTheme, size: 20),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.white54,
          ),
          child: FloatingActionButton(
            onPressed: () async {
              final dataProvider =
                  Provider.of<DataHandler>(context, listen: false);
              final List<Semester> semesters =
                  await dataProvider.getSemesters();
              final String givenName = _nameController.text;
              final String description = _descriptionController.text;
              if (givenName == "") {
                await showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      title: const Text("Please give a name for the semester"),
                      message: const Text("The name cannot be empty"),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text(
                            "Try again",
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (semesters
                  .map((s) => s.name)
                  .toSet()
                  .contains(givenName)) {
                await await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomAlertDialog.alertdialog(
                      title: "You already have a semester of with the name \"" +
                          givenName +
                          "\"",
                      content: "Please choose another name",
                      actions: [
                        MapEntry(
                          "Try again",
                          () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                final Semester newSemester = Semester(
                  name: givenName,
                  description: description,
                );
                final dataProvider =
                    Provider.of<DataHandler>(context, listen: false);
                await dataProvider.addSemester(newSemester);
                Navigator.pop(context);
              }
            },
            child: const Icon(
              CupertinoIcons.check_mark,
              size: 50,
            ),
            backgroundColor: Colors.red[400],
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

//  onPressed: () async {
//               final dataProvider =
//                   Provider.of<DataHandler>(context, listen: false);
//               final List<Semester> semesters = await dataProvider.getSemesters();
//               final String givenName = _nameController.text;
//               final String description = _descriptionController.text;
//               if (givenName == "") {
//                 await showCupertinoModalPopup(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return CupertinoActionSheet(
//                       title: const Text("Please give a name for the semester"),
//                       message: const Text("The name cannot be empty"),
//                       actions: [
//                         CupertinoActionSheetAction(
//                           child: const Text(
//                             "Try again",
//                             style: TextStyle(color: Colors.green),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               } else if (semesters
//                   .map((s) => s.name)
//                   .toSet()
//                   .contains(givenName)) {
//                 await await showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (BuildContext context) {
//                     return CustomAlertDialog.alertdialog(
//                       title: "You already have a semester of with the name \"" +
//                           givenName +
//                           "\"",
//                       content: "Please choose another name",
//                       actions: [
//                         MapEntry(
//                           "Try again",
//                           () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               } else {
//                 final Semester newSemester = Semester(
//                   name: givenName,
//                   description: description,
//                 );
//                 final dataProvider =
//                     Provider.of<DataHandler>(context, listen: false);
//                 await dataProvider.addSemester(newSemester);
//                 Navigator.pop(context);
//               }
//             },
