import 'package:flutter/material.dart';
import 'package:study_helper/objects/subject.dart';

class Chapter {
  String _chapterID;
  String _courseID;
  String _name;
  String _description;
  List<Subject> _subjects;
  Mastered _mas;

  Chapter(
      {@required String name,
      @required String courseID,
      String description = "",
      List<Subject> subjects = const [],
      Mastered mas = Mastered.Poorly}) {
    this._name = name;
    this._subjects = List.from(subjects);
    this._mas = mas;
    this._description = description;
    this._courseID = courseID;
    this._chapterID = UniqueKey().toString();
  }

  List<Subject> get subjects {
    return List.from(_subjects);
  }

  bool addSubject(Subject subject) {
    if (_subjects.contains(subject)) return false;
    _subjects.add(subject);
    return true;
  }

  String get id => _chapterID;

  String get courseID => _courseID;

  set name(String newName) => _name = newName;

  set mas(Mastered newMas) => _mas = newMas;

  Map<String, dynamic> toMap() {
    return {
      "ChapterID": id,
      "CourseID": courseID,
      "Name": this._name,
      "Description": this._description,
      "Mastered": this._mas,
    };
  }
}
