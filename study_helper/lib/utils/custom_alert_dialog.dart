import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog {
  static alertdialog({
    String title,
    String content,
    List<MapEntry<String, Function>> actions,
  }) {
    Text titleWidget, contentWidget;

    if (Platform.isIOS) {
      titleWidget = title == null ? null : Text(title);
      contentWidget = content == null ? null : Text(content);
    } else {
      titleWidget = title == null
          ? null
          : Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
              ),
            );
      contentWidget = content == null
          ? null
          : Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
              ),
            );
    }
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: List<Widget>.generate(
              actions?.length ?? 0,
              (i) {
                return CupertinoDialogAction(
                  child: Text(actions[i].key),
                  onPressed: actions[i].value,
                );
              },
            ),
          )
        : AlertDialog(
            backgroundColor: Color(0xFF111011),
            title: titleWidget,
            content: contentWidget,
            actions: List<Widget>.generate(
              actions?.length ?? 0,
              (i) {
                return FlatButton(
                  child: Text(
                    actions[i].key,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onPressed: actions[i].value,
                );
              },
            ),
          );
  }
}
