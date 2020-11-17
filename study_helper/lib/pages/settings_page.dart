import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Settings",
            textAlign: TextAlign.center,
            style: customTextStyle(themeChange.darkTheme),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(!themeChange.darkTheme
                      ? Icons.wb_sunny
                      : Ionicons.ios_moon),
                  title: Text(
                    "Dark mode",
                    style: customTextStyle(themeChange.darkTheme),
                    textAlign: TextAlign.center,
                  ),
                  trailing: CupertinoSwitch(
                    onChanged: (bool value) {
                      setState(() {
                        themeChange.darkTheme = value;
                      });
                    },
                    value: themeChange.darkTheme,
                  ),
                ),
                const SizedBox(height: 50),
                NiceButton(
                  themeChange.darkTheme,
                  text: "Reset data",
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
