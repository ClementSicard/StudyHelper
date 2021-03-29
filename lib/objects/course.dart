import 'package:flutter/material.dart';

class Course {
  String _courseID;
  String _semesterID;
  String _name;
  String _description;

  Course({
    @required String name,
    @required String semesterID,
    String description = "",
  }) {
    this._name = name;
    this._semesterID = semesterID;
    this._description = description;
    this._courseID = UniqueKey().toString();
  }

  String get id => _courseID;
  String get semesterId => _semesterID;
  String get name => _name;
  String get description => _description;

  Map<String, dynamic> toMap() {
    return {
      "CourseID": id,
      "SemesterID": _semesterID,
      "Name": name,
      "Description": description,
    };
  }
}
