import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/mastered.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class SubjectMasteredSliderDialog extends StatefulWidget {
  final Subject _subject;

  SubjectMasteredSliderDialog(this._subject, {Key key}) : super(key: key);

  @override
  _SubjectMasteredSliderDialogState createState() =>
      _SubjectMasteredSliderDialogState(_subject);
}

class _SubjectMasteredSliderDialogState
    extends State<SubjectMasteredSliderDialog> {
  double currentValue;
  final Subject _subject;

  _SubjectMasteredSliderDialogState(this._subject);

  @override
  void initState() {
    super.initState();
    print(_subject.mas);
    currentValue = _subject.mas.value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final bool darkTheme =
        Provider.of<DarkThemeProvider>(context, listen: false).darkTheme;

    return AlertDialog(
      elevation: 0,
      scrollable: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Text(
        'How comfortable are you with this subject?',
        style: customTextStyle(darkTheme),
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: SmoothStarRating(
                allowHalfRating: false,
                starCount: 3,
                rating: currentValue,
                size: 70.0,
                color: Colors.redAccent[100],
                borderColor: Colors.redAccent[100],
                spacing: 0.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text(
            'SAVE',
            style: TextStyle(
              color: Colors.greenAccent,
            ),
          ),
          onPressed: () async {
            Mastered mas = Mastered(currentValue.toInt());
            await Provider.of<DataHandler>(context, listen: false)
                .updateSubjectMastering(_subject, mas);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ChapterMasteredSliderDialog extends StatefulWidget {
  final Chapter chapter;

  ChapterMasteredSliderDialog(this.chapter, {Key key}) : super(key: key);

  @override
  _ChapterMasteredSliderDialogState createState() =>
      _ChapterMasteredSliderDialogState();
}

class _ChapterMasteredSliderDialogState
    extends State<ChapterMasteredSliderDialog> {
  double toBeSavedValue;
  double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.chapter.mas.value.toDouble();
    toBeSavedValue = currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final bool darkTheme =
        Provider.of<DarkThemeProvider>(context, listen: false).darkTheme;

    print(toBeSavedValue);

    return AlertDialog(
      elevation: 0,
      scrollable: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Text(
        'How comfortable are you with this chapter?',
        textAlign: TextAlign.center,
        style: customTextStyle(darkTheme),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: SmoothStarRating(
                allowHalfRating: false,
                starCount: 3,
                rating: currentValue,
                onRated: (newRating) {
                  setState(() {
                    toBeSavedValue = newRating;
                  });
                },
                size: 70.0,
                color: Colors.greenAccent,
                borderColor: Colors.greenAccent,
                spacing: 0.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text(
            'SAVE',
            style: TextStyle(
              color: Colors.greenAccent,
            ),
          ),
          onPressed: () async {
            Mastered mas = Mastered(toBeSavedValue.toInt());
            print(mas);
            await Provider.of<DataHandler>(context, listen: false)
                .updateChapterMastering(
              widget.chapter,
              mas,
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
