import 'package:study_helper/objects/subject.dart';

class Chapter {
  String _name;
  List<Subject> _subjects;

  Chapter(String name, List<Subject> subjects) {
    this._name = name;
    this._subjects = List.from(subjects);
  }

  List<Subject> get subjects {
    return List.from(_subjects);
  }

  bool addSubject(Subject subject) {
    if (_subjects.contains(subject)) return false;
    _subjects.add(subject);
    return true;
  }

  String get name {
    return _name;
  }

  set name(String newName) {
    _name = newName;
  }
}
