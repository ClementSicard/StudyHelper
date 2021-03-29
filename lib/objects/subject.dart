import 'package:flutter/material.dart';

class Subject {
  String _subjectID;
  String _chapterID;
  String _name;
  Mastered _mas;

  Subject({
    @required String name,
    @required String chapterID,
    Mastered mas = Mastered.Poorly,
  }) {
    this._name = name;
    this._chapterID = chapterID;
    this._subjectID = UniqueKey().toString();
    this._mas = mas;
  }

  set mas(Mastered mas) {
    _mas = mas;
  }

  String get id => _subjectID;
  String get chapterID => _chapterID;
  String get name => _name;

  Map<String, dynamic> toMap() {
    return {
      "SubjectID": id,
      "ChapterID": chapterID,
      "Name": name,
      "Mastered": _mas,
    };
  }
}

enum Mastered { Good, Moderately, Poorly }
