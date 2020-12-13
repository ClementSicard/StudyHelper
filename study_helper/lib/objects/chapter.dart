import 'package:study_helper/objects/subject.dart';

class Chapter {
  String _name;
  List<Subject> _subjects;
  Mastered _mas;

  Chapter(String name,
      {List<Subject> subjects = const [], Mastered mas = Mastered.Poorly}) {
    this._name = name;
    this._subjects = List.from(subjects);
    this._mas = mas;
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

  Mastered get mas {
    return _mas;
  }

  set name(String newName) {
    _name = newName;
  }

  set mas(Mastered newMas) {
    _mas = newMas;
  }
}
