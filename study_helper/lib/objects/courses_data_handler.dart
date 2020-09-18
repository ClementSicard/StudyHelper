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
              decodedChapters[i]["name"][0],
              subjects: List<Subject>.generate(
                  decodedChapters[i]["subjects"].length, (j) {
                return Subject(decodedChapters[i]["subjects"][j]);
              }),
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

    for (int i = 0; i < previousSave.length; i++) {
      if (previousSave[i]["name"] == course.name) {
        previousSave.removeAt(i);
      }
    }
    contents = jsonEncode(previousSave);
    await file.writeAsString(contents);

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

  Future<bool> addChapter(Course course, Chapter chapter) async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      return false;
    }

    List decodedContents = jsonDecode(contents);
    bool found = false;
    for (int i = 0; i < decodedContents.length; i++) {
      if (decodedContents[i]["name"] == course.name) {
        found = true;
        Map<String, List<String>> cMap = {
          "name": [chapter.name],
          "subjects": chapter.subjects.map((s) => s.name).toList()
        };
        decodedContents[i]["chapters"].add(cMap);
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
    }
    return found;
  }

  Future<bool> removeChapter(Course course, Chapter chapter) async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      return false;
    }

    List decodedContents = jsonDecode(contents);
    bool found = false;
    for (int i = 0; i < decodedContents.length; i++) {
      if (decodedContents[i]["name"] == course.name) {
        List chapters = decodedContents[i]["chapters"];
        for (int j = 0; j < chapters.length; j++) {
          print(chapters[j]["name"][0]);
          if (chapters[j]["name"][0] == chapter.name) {
            decodedContents[i]["chapters"].removeAt(j);
            found = true;
            print("Removed");
          }
        }
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
    }
    return found;
  }

  Future<bool> addSubject(
      Course course, Chapter chapter, Subject subject) async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      return false;
    }

    List decodedContents = jsonDecode(contents);
    bool found = false;
    for (int i = 0; i < decodedContents.length; i++) {
      if (decodedContents[i]["name"] == course.name) {
        for (int j = 0; j < decodedContents[i]["chapters"].length; j++) {
          print(decodedContents[i]["chapters"]);
          print(decodedContents[i]["chapters"][j]["name"][0]);
          if (decodedContents[i]["chapters"][j]["name"][0] == chapter.name) {
            found = true;
            decodedContents[i]["chapters"][j]["subjects"].add(subject.name);
          }
        }
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
      print("Subject saved!");
    }
    return found;
  }

  Future<bool> removeSubject(
      Course course, Chapter chapter, Subject subject) async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      return false;
    }

    List decodedContents = jsonDecode(contents);
    bool found = false;
    for (int i = 0; i < decodedContents.length; i++) {
      if (decodedContents[i]["name"] == course.name) {
        for (int j = 0; j < decodedContents[i]["chapters"].length; j++) {
          print(decodedContents[i]["chapters"]);
          print(decodedContents[i]["chapters"][j]["name"][0]);
          if (decodedContents[i]["chapters"][j]["name"][0] == chapter.name) {
            found = true;
            List subjects = decodedContents[i]["chapters"][j]["subjects"];
            for (int k = 0; k < subjects.length; k++) {
              if (subjects[k] == subject.name) {
                decodedContents[i]["chapters"][j]["subjects"].removeAt(k);
              }
            }
          }
        }
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
      print("Subject saved!");
    }
    return found;
  }

  List<Course> get courses => _courses;

  List<Chapter> getChapters(Course course) {
    for (Course c in _courses) {
      if (c.name == course.name) {
        return c.getChapters;
      }
    }
    print("On a pas trouvé le cours");
    return [];
  }
}
