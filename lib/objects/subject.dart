import 'package:flutter/material.dart';
import 'package:study_helper/objects/mastered.dart';

class Subject {
  String _subjectID;
  String _chapterID;
  String _name;
  Mastered _mas;
  bool _aside;

  Subject({
    @required String name,
    @required String chapterID,
    String id,
    Mastered mas = Mastered.Poorly,
    bool aside = false,
  }) {
    this._name = name;
    this._chapterID = chapterID;
    this._subjectID = id == null ? UniqueKey().toString() : id;
    this._mas = mas;
    this._aside = aside;
  }

  set mas(Mastered mas) {
    this._mas = mas;
  }

  String get id => _subjectID;
  String get chapterID => _chapterID;
  String get name => _name;
  Mastered get mas => _mas;
  bool get aside => _aside;

  Map<String, dynamic> toMap() {
    return {
      "SubjectID": id,
      "ChapterID": chapterID,
      "Name": name,
      "Mastered": this._mas.value,
      "Aside": aside ? 1 : 0,
    };
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
