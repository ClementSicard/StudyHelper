import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/subject.dart';

class Course {
  String _name;
  List<Chapter> _chapters;

  Course(String name, {List<Chapter> chapters = const []}) {
    this._name = name;
    this._chapters = chapters;
  }

  List<List<Subject>> get subjects {
    List<List<Subject>> list = List();
    for (Chapter chapter in _chapters) {
      list.add(chapter.subjects);
    }
    return list;
  }

  List<Chapter> get getChapters => _chapters;

  String get name => _name;

  set name(String newName) {
    _name = newName;
  }
}

enum Mastered { Good, Moderately, Poorly }
