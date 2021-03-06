import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/subject.dart';

class Course {
  String _name;
  List<Chapter> _chapters;
  String _description;

  Course(String name,
      {List<Chapter> chapters = const [], String description = ""}) {
    this._name = name;
    this._chapters = chapters;
    this._description = description;
  }

  List<List<Subject>> get subjects {
    List<List<Subject>> list = [];
    for (Chapter chapter in _chapters) {
      list.add(chapter.subjects);
    }
    return list;
  }

  List<Chapter> get getChapters => List.from(_chapters);
  String get name => _name;
  String get description => _description;

  set name(String newName) {
    _name = newName;
  }
}
