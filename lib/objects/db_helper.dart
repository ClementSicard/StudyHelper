import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/mastered.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/objects/subject.dart';

class DBHelper {
  static final databaseName = 'courses.db';
  static final _databaseVersion = 1;
  static final table = "courses";

  final _subjectCreationQuery = '''CREATE TABLE Subject(
        SubjectID varchar(1000), 
        ChapterID varchar(1000), 
        Name varchar(100), 
        Mastered integer, 
        PRIMARY KEY (SubjectID)
        );''';
  final _chapterCreationQuery = '''CREATE TABLE Chapter(
        ChapterID varchar(1000), 
        CourseID varchar(1000), 
        Name varchar(100), 
        Description varchar(1000),
        Mastered integer,
        PRIMARY KEY (ChapterID)
        );''';
  final _courseCreationQuery = '''CREATE TABLE Course(
        CourseID varchar(1000), 
        SemesterID varchar(1000), 
        Name varchar(100), 
        Description varchar(1000), 
        PRIMARY KEY (CourseID)
        );''';
  final _semesterCreationQuery = '''CREATE TABLE Semester(
        SemesterID varchar(1000), 
        Name varchar(100), 
        Description varchar(1000), 
        PRIMARY KEY (SemesterID, Name)
        );''';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_subjectCreationQuery);
    await db.execute(_chapterCreationQuery);
    await db.execute(_courseCreationQuery);
    await db.execute(_semesterCreationQuery);
    print("[DBHelper] Database was created!");
  }

  Future<void> clearDB(Database db) async {
    final Database db = await DBHelper.instance.database;

    await db.delete('Course');
    await db.delete('Semester');
    await db.delete('Chapter');
    await db.delete('Subject');
  }

  // Course methods

  Future<void> addCourse(Course course) async {
    final Database db = await database;

    await db.insert(
      'Course',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> renameCourse(Course course, String newName) async {
    final Database db = await database;
    var row = course.toMap();
    row["Name"] = newName;

    await db.update(
      'Course',
      row,
      where: "CourseID = ?",
      whereArgs: [course.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCourse(Course course) async {
    final Database db = await database;

    await db.delete(
      'Course',
      where: "CourseID = ?",
      whereArgs: [course.id],
    );
  }

  Future<void> updateCourseDescription(
      Course course, String newDescription) async {
    final Database db = await database;
    var row = course.toMap();
    row["Description"] = newDescription;

    await db.update(
      'Course',
      row,
      where: 'CourseID = ?',
      whereArgs: [course.id],
    );
  }

  // Chapter methods

  Future<void> addChapter(Chapter chapter) async {
    final Database db = await database;

    await db.insert(
      'Chapter',
      chapter.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> renameChapter(Chapter chapter, String newName) async {
    final Database db = await database;
    var row = chapter.toMap();
    row["Name"] = newName;

    await db.update(
      'Chapter',
      row,
      where: "ChapterID = ?",
      whereArgs: [chapter.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteChapter(Chapter chapter) async {
    final Database db = await database;

    await db.delete(
      'Chapter',
      where: "ChapterID = ?",
      whereArgs: [chapter.id],
    );
  }

  Future<void> updateChapterMastering(Chapter chapter, Mastered mas) async {
    final Database db = await database;
    var row = chapter.toMap();
    row["Mastered"] = mas.value;

    await db.update(
      'Chapter',
      row,
      where: 'ChapterID = ?',
      whereArgs: [chapter.id],
    );
  }

  // Subject methods

  Future<void> addSubject(Subject subject) async {
    final Database db = await database;

    await db.insert(
      'Subject',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> renameSubject(Subject subject, String newName) async {
    final Database db = await database;
    var row = subject.toMap();
    row["Name"] = newName;

    await db.update(
      'Subject',
      row,
      where: "SubjectID = ?",
      whereArgs: [subject.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSubject(Subject subject) async {
    final Database db = await database;

    await db.delete(
      'Subject',
      where: "SubjectID = ?",
      whereArgs: [subject.id],
    );
  }

  Future<void> updateSubjectMastering(Subject subject, Mastered mas) async {
    final Database db = await database;
    var row = subject.toMap();
    row["Mastered"] = mas.value;

    await db.update(
      'Subject',
      row,
      where: 'SubjectID = ?',
      whereArgs: [subject.id],
    );
  }

  // Semester methods

  Future<void> addSemester(Semester semester) async {
    final Database db = await database;

    await db.insert(
      'Semester',
      semester.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> renameSemester(
    Semester semester,
    String newName,
  ) async {
    final Database db = await database;
    var row = semester.toMap();
    row["Name"] = newName;

    await db.update(
      'Semester',
      row,
      where: "SemesterID = ?",
      whereArgs: [semester.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSemester(Semester semester) async {
    final Database db = await database;

    await db.delete(
      'Semester',
      where: "SemesterID = ?",
      whereArgs: [semester.id],
    );
  }

  Future<void> updateSemesterDescription(
      Semester semester, String newDescription) async {
    final Database db = await database;
    var row = semester.toMap();
    row["Description"] = newDescription;

    await db.update(
      'Semester',
      row,
      where: "SemesterID = ?",
      whereArgs: [semester.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Backup methods

  Future<File> getDBFile() async {
    print("");
  }
}
