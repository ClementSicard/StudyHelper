import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/db_helper.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/objects/subject.dart';

class CoursesDataHandler with ChangeNotifier {
  List<Semester> _semesters;

  CoursesDataHandler() {
    _update();
  }

  Future<bool> clear() async {}

  Future<bool> _update() async {
    final Database db = await DBHelper.instance.database;

    List<Map> semestersFromDB = await db.query('Semester');
    List<Semester> semesters = semestersFromDB
        .map(
          (m) => Semester(
              id: m["SemesterID"],
              name: m["Name"],
              description: m["Description"]),
        )
        .toList();

    for (Semester semester in semesters) {
      final List<Course> courses = await _getCoursesFromDB(db, semester.id);
      semester.courses = courses;
    }

    _semesters = semesters;
    notifyListeners();
    return true;
  }

  Future<List<Course>> _getCoursesFromDB(Database db, String semesterID) async {
    final List<Map> coursesFromDB = await db.query(
      'Course',
      where: "SemesterID = ?",
      whereArgs: [semesterID],
    );

    final List<Course> courses = coursesFromDB.map((c) {
      return Course(
        name: c["Name"],
        id: c["CourseID"],
        semesterID: semesterID,
      );
    }).toList();

    for (Course course in courses) {
      final List<Chapter> chapters =
          await _getChaptersFromDB(db, semesterID, course.id);
      course.chapters = chapters;
    }

    return courses;
  }

  Future<List<Chapter>> _getChaptersFromDB(
      Database db, String semesterID, String courseID) async {
    var query = '''
        SELECT Chapter.ChapterID, Chapter.Name, Chapter.Mastered, Chapter.Description FROM Semester 
          JOIN Course 
            JOIN Chapter 
            ON Chapter.CourseID = Course.CourseID 
          ON Course.SemesterID = Semester.SemesterID
        WHERE 
          Semester.SemesterID = '$semesterID' 
          AND Course.CourseID = '$courseID';
        ''';

    final List<Map> chaptersFromDB = await db.rawQuery(query);

    final List<Chapter> chapters = chaptersFromDB
        .map(
          (m) => Chapter(
            id: m["ChapterID"],
            name: m["Name"],
            mas: m["Mastered"],
            description: m["Description"],
            courseID: courseID,
          ),
        )
        .toList();

    for (Chapter chapter in chapters) {
      final List<Subject> subjects =
          await _getSubjectsFromDB(db, semesterID, courseID, chapter.id);
      chapter.subjects = subjects;
    }

    return chapters;
  }

  Future<List<Subject>> _getSubjectsFromDB(
      Database db, String semesterID, String courseID, String chapterID) async {
    var query = '''
        SELECT Subject.SubjectID, Subject.Name, Subject.Mastered FROM Semester 
          JOIN Course 
            JOIN Chapter 
              JOIN Subject 
              ON Subject.ChapterID = Chapter.ChapterID 
            ON Chapter.CourseID = Course.CourseID 
          ON Course.SemesterID = Semester.SemesterID
        WHERE 
          Semester.SemesterID = '$semesterID' 
          AND Course.CourseID = '$courseID'
          AND Chapter.ChapterID = '$chapterID';
        ''';

    List<Map> subjectsFromDB = await db.rawQuery(query);

    List<Subject> subjects = subjectsFromDB
        .map(
          (m) => Subject(
            id: m["SubjectID"],
            name: m["Name"],
            mas: m["Mastered"],
            chapterID: chapterID,
          ),
        )
        .toList();

    return subjects;
  }

// Semester methods

  Future<bool> addSemester(Semester semester) async {
    await DBHelper.instance.addSemester(semester);
    await _update();
    print("[CoursesDataHandler] Semester well added!");
    return true;
  }

  Future<bool> renameSemester(Semester semester, String newName) async {
    await DBHelper.instance.renameSemester(semester, newName);
    await _update();
    print("[CoursesDataHandler] Semester well renamed!");
    return true;
  }

  Future<bool> removeSemester(Semester semester) async {
    await DBHelper.instance.deleteSemester(semester);
    await _update();
    print("[CoursesDataHandler] Semester well removed!");
    return true;
  }

// Course methods

  Future<bool> addCourse(Course course) async {
    await DBHelper.instance.addCourse(course);
    await _update();
    print("[CoursesDataHandler] Course well added!");
    return true;
  }

  Future<bool> removeCourse(Course course) async {
    await DBHelper.instance.deleteCourse(course);
    await _update();
    print("[CoursesDataHandler] Course well deleted!");
    return true;
  }

  Future<bool> renameCourse(Course course, String newName) async {
    await DBHelper.instance.renameCourse(course, newName);
    await _update();
    print("[CoursesDataHandler] Course well renamed!");
    return true;
  }

// Chapter methods

  Future<bool> addChapter(Chapter chapter) async {
    await DBHelper.instance.addChapter(chapter);
    await _update();
    print("[CoursesDataHandler] Chapter well added!");
    return true;
  }

  Future<bool> renameChapter(Chapter chapter, String newName) async {
    await DBHelper.instance.renameChapter(chapter, newName);
    await _update();
    print("[CoursesDataHandler] Chapter well renamed!");
    return true;
  }

  Future<bool> removeChapter(Chapter chapter) async {
    await DBHelper.instance.deleteChapter(chapter);
    await _update();
    print("[CoursesDataHandler] Chapter well removed!");
    return true;
  }

// Subject methods

  Future<bool> addSubject(Subject subject) async {
    await DBHelper.instance.addSubject(subject);
    await _update();
    print("[CoursesDataHandler] Subject well added!");
    return true;
  }

  Future<bool> renameSubject(
      Course course, Chapter chapter, Subject subject, String newName) async {
    await DBHelper.instance.addSubject(subject);
    await _update();
    print("[CoursesDataHandler] Subject well renamed!");
    return true;
  }

  Future<bool> removeSubject(Subject subject) async {
    await DBHelper.instance.deleteSubject(subject);
    await _update();
    print("[CoursesDataHandler] Subject well removed!");
    return true;
  }

  Future<List<Semester>> getSemesters() async {
    if (_semesters == null) {
      await _update();
    }
    return _semesters;
  }
}
