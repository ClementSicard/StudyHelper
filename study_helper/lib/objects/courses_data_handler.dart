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
    print(dir.path);
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      contents = "";
    }

    List<Map<String, Map<String, Mastered>>> chapters =
        List<Map<String, Map<String, Mastered>>>.generate(
      course.getChapters.length,
      (index) {
        final Chapter currentChapter = course.getChapters[index];
        return {
          "name": Map.fromIterable(
              [MapEntry(currentChapter.name, currentChapter.mas)]),
          "subjects": Map<String, Mastered>.fromIterable(
              currentChapter.subjects.map((s) => MapEntry(s.name, s.mas))),
          // "subjects": currentChapter.subjects
          //     .map((s) => MapEntry(s.name, s.mas.toString()))
          //     .toList()
        };
      },
    );

    final Map toAdd = {
      "name": course.name,
      "chapters": chapters,
      "description": course.description,
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
            print(decodedChapters[i]["name"]);
            var subs = decodedChapters[i]["subjects"];
            return Chapter(
              decodedChapters[i]["name"]
                  [decodedChapters[i]["name"][0].keys()[0]],
              subjects: List<Subject>.generate(subs.keys().length, (j) {
                var name = subs.keys()[j];
                var mas = subs[subs.keys()[j]];
                return Subject(name, mas: mas);
              }),
            );
          },
        );
        return Course(decodedContents[index]["name"],
            description: decodedContents[index]["description"],
            chapters: chapters);
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
        Map<String, Map<String, Mastered>> cMap = {
          "name": Map.fromIterable([chapter.name, chapter.mas]),
          "subjects": Map.fromIterable(
              chapter.subjects.map((s) => MapEntry(s.name, s.mas)))
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
          if (chapters[j]["name"][chapters[j]["name"].keys()[0]] ==
              chapter.name) {
            decodedContents[i]["chapters"].removeAt(j);
            found = true;
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

  Future<bool> renameChapter(
      Course course, Chapter chapter, String newName) async {
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
          var currentChapName = chapters[j]["name"];
          if (currentChapName[currentChapName.keys()[0]] == chapter.name) {
            chapters[j]["name"] =
                Map.fromIterable([MapEntry(newName, chapter.mas)]);
            found = true;
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
          var currentChapName = decodedContents[i]["chapters"][j]["name"];
          if (currentChapName[currentChapName.keys()[0]] == chapter.name) {
            found = true;
            decodedContents[i]["chapters"][j]["subjects"]
                .add(MapEntry(subject.name, subject.mas));
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
          var currentChapName = decodedContents[i]["chapters"][j]["name"];
          if (currentChapName[currentChapName.keys()[0]] == chapter.name) {
            found = true;
            Map subjects = decodedContents[i]["chapters"][j]["subjects"];
            for (int k = 0; k < subjects.length; k++) {
              if (subjects[subjects.keys()[k]] == subject.name) {
                decodedContents[i]["chapters"][j]["subjects"]
                    .remove(subjects[k]);
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
      print("Subject removed!");
    } else {
      print("ça marche pas encore bg");
    }
    return found;
  }

  Future<bool> renameSubject(
      Course course, Chapter chapter, Subject subject, String newName) async {
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
          var currentChapName = decodedContents[i]["chapters"][j]["name"];
          if (currentChapName[currentChapName.keys()[0]] == chapter.name) {
            found = true;
            Map subjects = decodedContents[i]["chapters"][j]["subjects"];
            for (int k = 0; k < subjects.length; k++) {
              if (subjects[k].key == subject.name) {
                decodedContents[i]["chapters"][j]["subjects"][k] =
                    MapEntry(newName, subject.mas);
              }
            }
            for (MapEntry s in subjects) {}
          }
        }
      }
    }
    if (found) {
      contents = jsonEncode(decodedContents);
      await file.writeAsString(contents);
      _update();
      print("Subject renamed!");
    } else {
      print("ça marche pas encore bg");
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

  Future<File> exportJSONFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = await file.readAsString();
    } else {
      contents = "";
    }

    final File backupFile = File("${dir.path}/courses_data_export.json");
    await backupFile.writeAsString(contents);
    return backupFile;
  }

  Future<void> deleteData() async {
    for (Course c in this._courses) {
      await removeCourse(c);
    }
    print("Data deleted!");
  }

  Future<bool> overwriteData(String newContent) async {
    var json = jsonDecode(newContent);
    List test = json[0]["chapters"];
    if (test == null) {
      throw Exception("Not well structured JSON file for this application");
    }
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");
    String contents;
    if (await file.exists()) {
      contents = newContent;
    } else {
      return false;
    }
    await file.writeAsString(contents);
    _update();
    return true;
  }

  Future<int> mergeData(String newContent) async {
    int count = 0;
    var json = jsonDecode(newContent);
    List test = json[0]["chapters"];
    if (test == null) {
      throw Exception("Not well structured JSON file for this application");
    }
    if (_courses == null || _courses.isEmpty) {
      overwriteData(newContent);
      return json.length;
    } else {
      for (int i = 0; i < json.length; i++) {
        var current = json[i];
        if (!_courses.map((c) => c.name).toSet().contains(current["name"])) {
          count++;
          List<Chapter> chapters = [];
          for (int j = 0; j < current["chapters"].length; j++) {
            var chap = current["chapters"][j];
            Chapter chapter = Chapter(chap["name"][chap["name"].keys()[0]]);
            for (MapEntry s in chap["subjects"]) {
              chapter.addSubject(Subject(s.key, mas: s.value));
            }
          }
          Course course = Course(current["name"], chapters: chapters);
          await save(course);
        }
      }
      return count;
    }
  }
}
