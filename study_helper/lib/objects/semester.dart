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

enum Mastered { Good, Moderately, Poorly }
