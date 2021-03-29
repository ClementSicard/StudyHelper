import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';

class DBHelper {
  static final _databaseName = 'courses.db';
  static final _databaseVersion = 1;
  static final table = "courses";

  final _subjectCreationQuery = '''CREATE TABLE   Subject(
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
        PRIMARY KEY (SemesterID)
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
    String path = join(dbPath, _databaseName);
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

  // Course methods

  Future<void> addCourse(Course course) async {
    final Database db = await database;
    await db.insert(
      'Course',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> renameCourse(
    Course course,
    String newName,
  ) async {
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

  // Chapter methods

  Future<void> addChapter(Chapter chapter) async {
    await 
  }

}
