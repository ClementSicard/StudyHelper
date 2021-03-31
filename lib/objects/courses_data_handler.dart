import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/db_helper.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/objects/subject.dart';

class DataHandler with ChangeNotifier {
  List<Semester> _semesters;

  DataHandler() {
    _update();
  }

  Future<bool> clearData() async {
    final Database db = await DBHelper.instance.database;
    await DBHelper.instance.clearDB(db);
    await _update();
    print("[DataHandler] Data successfully cleared!");
    return true;
  }

  Future<bool> _update() async {
    final Database db = await DBHelper.instance.database;
    List<Map> semestersFromDB = await db.query('Semester');

    List<Semester> semesters = semestersFromDB.isNotEmpty
        ? semestersFromDB
            .map(
              (m) => Semester(
                  id: m["SemesterID"],
                  name: m["Name"],
                  description: m["Description"]),
            )
            .toList()
        : [];

    for (Semester semester in semesters) {
      final List<Course> courses = await _getCoursesFromDB(db, semester.id);
      semester.courses = courses;
    }

    this._semesters = semesters;
    notifyListeners();
    return true;
  }

  Future<List<Course>> getCoursesFromSemester(Semester semester) async {
    final Database db = await DBHelper.instance.database;
    final List<Course> courses = await _getCoursesFromDB(db, semester.id);
    return courses;
  }

  Future<List<Chapter>> getChaptersFromCourse(Course course) async {
    final Database db = await DBHelper.instance.database;
    final List<Chapter> chapters = await _getChaptersFromDB(
      db,
      course.id,
    );
    return chapters;
  }

  Future<List<Subject>> getSubjectsFromChapter(Chapter chapter) async {
    final Database db = await DBHelper.instance.database;
    final List<Subject> subjects = await _getSubjectsFromDB(
      db,
      chapter.id,
    );
    return subjects;
  }

  Future<List<Course>> _getCoursesFromDB(Database db, String semesterID) async {
    final List<Map> coursesFromDB = await db.query(
      'Course',
      where: "SemesterID = ?",
      whereArgs: [semesterID],
    );

    final List<Course> courses = coursesFromDB.isNotEmpty
        ? coursesFromDB.map(
            (c) {
              return Course(
                name: c["Name"],
                id: c["CourseID"],
                semesterID: semesterID,
              );
            },
          ).toList()
        : [];

    for (Course course in courses) {
      final List<Chapter> chapters = await _getChaptersFromDB(db, semesterID);
      course.chapters = chapters;
    }

    return courses;
  }

  Future<List<Chapter>> _getChaptersFromDB(Database db, String courseID) async {
    var query = '''
        SELECT Chapter.ChapterID, Chapter.Name, Chapter.Mastered, Chapter.Description FROM Course 
          JOIN Chapter 
          ON Chapter.CourseID = Course.CourseID 
        WHERE 
          Course.CourseID = ?;
        ''';

    final List<Map> chaptersFromDB = await db.rawQuery(query, [courseID]);

    final List<Chapter> chapters = chaptersFromDB.isNotEmpty
        ? chaptersFromDB
            .map(
              (m) => Chapter(
                id: m["ChapterID"],
                name: m["Name"],
                mas: m["Mastered"],
                description: m["Description"],
                courseID: courseID,
              ),
            )
            .toList()
        : [];

    for (Chapter chapter in chapters) {
      final List<Subject> subjects = await _getSubjectsFromDB(db, chapter.id);
      chapter.subjects = subjects;
    }

    return chapters;
  }

  Future<List<Subject>> _getSubjectsFromDB(
      Database db, String chapterID) async {
    var query = '''
        SELECT Subject.SubjectID, Subject.Name, Subject.Mastered FROM Chapter 
          JOIN Subject 
          ON Subject.ChapterID = Chapter.ChapterID 
        WHERE 
          Chapter.ChapterID = ?;
        ''';

    List<Map> subjectsFromDB = await db.rawQuery(query, [chapterID]);

    List<Subject> subjects = subjectsFromDB.isNotEmpty
        ? subjectsFromDB
            .map(
              (m) => Subject(
                id: m["SubjectID"],
                name: m["Name"],
                mas: m["Mastered"],
                chapterID: chapterID,
              ),
            )
            .toList()
        : [];

    return subjects;
  }

// Semester methods

  Future<bool> addSemester(Semester semester) async {
    await DBHelper.instance.addSemester(semester);
    await _update();
    print("[DataHandler] Semester well added!");
    return true;
  }

  Future<bool> renameSemester(Semester semester, String newName) async {
    await DBHelper.instance.renameSemester(semester, newName);
    await _update();
    print("[DataHandler] Semester well renamed!");
    return true;
  }

  Future<bool> removeSemester(Semester semester) async {
    await DBHelper.instance.deleteSemester(semester);
    await _update();
    print("[DataHandler] Semester well removed!");
    return true;
  }

// Course methods

  Future<bool> addCourse(Course course) async {
    await DBHelper.instance.addCourse(course);
    await _update();
    print("[DataHandler] Course well added!");
    return true;
  }

  Future<bool> removeCourse(Course course) async {
    await DBHelper.instance.deleteCourse(course);
    await _update();
    print("[DataHandler] Course well deleted!");
    return true;
  }

  Future<bool> renameCourse(Course course, String newName) async {
    await DBHelper.instance.renameCourse(course, newName);
    await _update();
    print("[DataHandler] Course well renamed!");
    return true;
  }

// Chapter methods

  Future<bool> addChapter(Chapter chapter) async {
    await DBHelper.instance.addChapter(chapter);
    await _update();
    print("[DataHandler] Chapter well added!");
    return true;
  }

  Future<bool> renameChapter(Chapter chapter, String newName) async {
    await DBHelper.instance.renameChapter(chapter, newName);
    await _update();
    print("[DataHandler] Chapter well renamed!");
    return true;
  }

  Future<bool> removeChapter(Chapter chapter) async {
    await DBHelper.instance.deleteChapter(chapter);
    await _update();
    print("[DataHandler] Chapter well removed!");
    return true;
  }

// Subject methods

  Future<bool> addSubject(Subject subject) async {
    await DBHelper.instance.addSubject(subject);
    await _update();
    print("[DataHandler] Subject well added!");
    return true;
  }

  Future<bool> renameSubject(
      Course course, Chapter chapter, Subject subject, String newName) async {
    await DBHelper.instance.addSubject(subject);
    await _update();
    print("[DataHandler] Subject well renamed!");
    return true;
  }

  Future<bool> removeSubject(Subject subject) async {
    await DBHelper.instance.deleteSubject(subject);
    await _update();
    print("[DataHandler] Subject well removed!");
    return true;
  }

  Future<List<Semester>> getSemesters() async {
    if (_semesters == null) {
      await _update();
    }
    return this._semesters;
  }
}
