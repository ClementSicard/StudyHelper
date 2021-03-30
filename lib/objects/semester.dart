import 'package:flutter/material.dart';

import 'course.dart';

class Semester {
  String _semesterID;
  String _name;
  String _description;
  List<Course> _courses;

  Semester({
    @required String name,
    String description = "",
    String id,
    List<Course> courses,
  }) {
    this._semesterID = id == null ? UniqueKey().toString() : id;
    this._name = name;
    this._description = description;
    this._courses = courses == null ? [] : courses;
  }

  String get id => _semesterID;
  String get name => _name;
  String get description => _description;
  List<Course> get courses => _courses;
  set courses(List<Course> courses) => _courses = courses;

  Map<String, dynamic> toMap() {
    return {
      "SemesterID": this.id,
      "Name": this.name,
      "Description": this.description,
    };
  }
}
