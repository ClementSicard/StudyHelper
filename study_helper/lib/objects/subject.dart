import 'package:study_helper/objects/course.dart';

class Subject {
  String _name;
  Mastered _mas;

  Subject(String name, {Mastered mas = Mastered.Poorly}) {
    this._name = name;
    this._mas = mas;
  }

  set mas(Mastered mas) {
    _mas = mas;
  }

  String get name {
    return _name;
  }

  set name(String name) {
    _name = name;
  }
}
