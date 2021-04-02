import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:slide_popup_dialog/slide_dialog.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/pages/semester_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/device.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:study_helper/utils/routes.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _test = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Ionicons.ios_school,
              color: Colors.orange,
              size: 40,
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: customTextStyle(themeChange.darkTheme, size: 30),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: 10.0 / 360.0 * MediaQuery.of(context).size.width),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.gear_solid,
                size: 35,
              ),
              splashColor: Colors.transparent,
              onPressed: () async => await showGeneralDialog(
                context: context,
                pageBuilder: (context, animation1, animation2) {},
                barrierLabel: "Dismiss",
                barrierDismissible: true,
                transitionBuilder: (context, animation1, animation2, widget) {
                  final curvedValue =
                      Curves.easeInOut.transform(animation1.value) - 1.0;
                  return StatefulBuilder(
                    builder: (context, setStater) => Transform(
                      transform: Matrix4.translationValues(
                          0.0, curvedValue * -400, 0.0),
                      child: Opacity(
                        opacity: animation1.value,
                        child: SlideDialog(
                          pillColor: Colors.orangeAccent,
                          backgroundColor: Theme.of(context).canvasColor,
                          child: _settingsCard(themeChange, setState),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome back to StudyHelper!',
                textAlign: TextAlign.center,
                style: customTextStyle(
                  themeChange.darkTheme,
                  size: 30,
                ),
              ),
              const SizedBox(height: 60),
              NiceButton(
                themeChange.darkTheme,
                onPressed: () async => await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SemestersPage()),
                ),
                text: "Start studying",
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsCard(DarkThemeProvider themeChange, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                !themeChange.darkTheme ? Icons.wb_sunny : Ionicons.ios_moon,
              ),
              title: Text(
                "Dark mode",
                style: customTextStyle(themeChange.darkTheme, size: 25),
                textAlign: TextAlign.center,
              ),
              trailing: CupertinoSwitch(
                onChanged: (bool value) {
                  setState(
                    () {
                      themeChange.darkTheme = value;
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor:
                              value ? Colors.black : Colors.transparent,
                        ),
                      );
                    },
                  );
                },
                value: themeChange.darkTheme,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: NiceButton(
                themeChange.darkTheme,
                text: "Reset data",
                color: Colors.redAccent,
                height: 70,
                onPressed: () async => await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text("Warning"),
                    message: const Text(
                        "Are you sure that you want to delete all saved data ?"),
                    actions: [
                      CupertinoActionSheetAction(
                        child: const Text("OK"),
                        isDestructiveAction: true,
                        onPressed: () async {
                          await Provider.of<DataHandler>(context, listen: false)
                              .clearData();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        "Cancel",
                        style: const TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
