import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/subject.dart';

class CoursesDataHandler with ChangeNotifier {
  List<Course> _courses;

  CoursesDataHandler() {
    _update();
  }

  Future<bool> save(Course course) async {
    if (course == null) {
      return true;
    }

    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      contents = "";
    }

    List<Map<String, List<String>>> chapters =
        List<Map<String, List<String>>>.generate(
      course.getChapters.length,
      (index) {
        Chapter currentChapter = course.getChapters[index];
        return {
          "name": [currentChapter.name],
          "subjects": currentChapter.subjects.map((s) => s.name).toList()
        };
      },
    );

    final Map toAdd = {
      "name": course.name,
      "chapters": chapters,
    };

    dynamic previousSave;
    print(contents);
    if (contents.isEmpty) {
      previousSave = [toAdd];
    } else {
      previousSave = jsonDecode(contents);
      previousSave.add(toAdd);
    }

    contents = jsonEncode(previousSave);
    await file.writeAsString(contents);

    _update();
    return true;
  }

  Future<bool> renameCourse(Course course, String name) async {
    if (course == null) {
      return false;
    }

    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      print("Couldn't rename the course : file doesn't exist");
      return false;
    }

    List decodedContents = jsonDecode(contents);

    bool found = false;
    for (int i = 0; i < decodedContents.length; i++) {
      if (decodedContents[i]["name"] == course.name) {
        found = true;
        decodedContents[i]["name"] = name;
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
    }
    print(found);
    return found;
  }

  Future<void> updateCourse(Course course) async {
    assert(course != null);
    await removeCourse(course);
    await save(course);
  }

  Future<bool> _update() async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");

    if (!await file.exists()) {
      _courses = [];
      notifyListeners();
      return true;
    }
    String contents = await file.readAsString();
    final List decodedContents = jsonDecode(contents);

    List<Course> courses = List<Course>.generate(
      decodedContents.length,
      (index) {
        final decodedChapters = decodedContents[index]["chapters"];
        List<Chapter> chapters = List<Chapter>.generate(
          decodedChapters.length,
          (i) {
            return Chapter(
              decodedChapters[i]["name"],
              decodedChapters[i]["subjects"].map((s) => Subject(s)).toList(),
            );
          },
        );
        return Course(decodedContents[index]["name"], chapters: chapters);
      },
    );
    _courses = courses;
    notifyListeners();
    return true;
  }

  Future<bool> removeCourseAtIndex(int index) async {
    assert(index >= 0);

    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");

    if (!await file.exists()) {
      _courses = [];
      notifyListeners();
      return true;
    }
    String contents = await file.readAsString();
    final List previousSave = jsonDecode(contents);

    if (index >= previousSave.length) {
      return false;
    }
    previousSave.removeAt(index);
    contents = jsonEncode(previousSave);
    await file.writeAsString(contents);
    _update();
    return true;
  }

  Future<bool> removeCourse(Course course) async {
    assert(course != null);

    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");

    if (!await file.exists()) {
      _courses = [];
      notifyListeners();
      return true;
    }
    String contents = await file.readAsString();
    final List previousSave = jsonDecode(contents);
    print(previousSave);

    for (int i = 0; i < previousSave.length; i++) {
      print(previousSave[i]["name"] + " vs " + course.name);
      bool test = previousSave[i]["name"] == course.name;
      print(test);
      if (previousSave[i]["name"] == course.name) {
        previousSave.removeAt(i);
      }
    }
    contents = jsonEncode(previousSave);
    await file.writeAsString(contents);
    print(contents);
    _update();
    return true;
  }

  Future<bool> clear() async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      return false;
    }

    List previousSave = jsonDecode(contents);
    previousSave.clear();

    contents = jsonEncode(previousSave);
    await file.writeAsString(contents);
    _update();
    return true;
  }

  List<Course> get courses => _courses;
}
