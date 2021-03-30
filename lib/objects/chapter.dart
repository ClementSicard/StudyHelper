import 'package:flutter/material.dart';
import 'package:study_helper/objects/subject.dart';

class Chapter {
  String _chapterID;
  String _courseID;
  String _name;
  String _description;
  List<Subject> subjects;
  Mastered _mas;

  Chapter(
      {@required String name,
      @required String courseID,
      String description = "",
      String id,
      List<Subject> subjects,
      Mastered mas = Mastered.Poorly}) {
    this._name = name;
    this._mas = mas;
    this._description = description;
    this._courseID = courseID;
    this.subjects = subjects == null ? [] : subjects;
    this._chapterID = id == null ? UniqueKey().toString() : id;
  }

  String get id => _chapterID;
  String get name => _name;
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
