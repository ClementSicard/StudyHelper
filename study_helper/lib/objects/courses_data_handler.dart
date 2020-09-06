import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_helper/objects/semester.dart';

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

  Future<bool> _update() async {
    final dir = await getApplicationDocumentsDirectory();
    final File file = File("${dir.path}/courses_data.json");

    if (!await file.exists()) {
      _courses = List();
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
  }

  Future<bool> remove(int index) async {}

  Future<bool> clear() async {}

  List<Course> get courses => _courses;
}
