import 'package:flutter/material.dart';
import 'chapter.dart';

class Course {
  String _courseID;
  String _semesterID;
  String _name;
  String _description;
  List<Chapter> _chapters;

  Course({
    @required String name,
    @required String semesterID,
    String id,
    List<Chapter> chapters,
    String description = "",
  }) {
    this._name = name;
    this._semesterID = semesterID;
    this._description = description;
    this._courseID = id == null ? UniqueKey().toString() : id;
    this._chapters = chapters == null ? [] : chapters;
  }

  String get id => _courseID;
  String get semesterId => _semesterID;
  String get name => _name;
  List<Chapter> get chapters => _chapters;

  set chapters(List<Chapter> chapters) => _chapters = chapters;

  String get description => _description;

  Map<String, dynamic> toMap() {
    return {
      "CourseID": this.id,
      "SemesterID": this._semesterID,
      "Name": this.name,
      "Description": this.description,
    };
  }
}
