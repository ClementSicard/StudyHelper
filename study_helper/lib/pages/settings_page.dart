import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Settings",
            textAlign: TextAlign.center,
            style: customTextStyle(),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              "No settings available at the moment.",
              style: customTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
