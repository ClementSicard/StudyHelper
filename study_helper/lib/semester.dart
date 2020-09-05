class Semester {
  String _name;
  List<Course> _courses;

  Semester(String name) {
    _name = name;
    _courses = List();
  }

  bool addCourse(Course course) {
    if (course.name != "" && course.subjects != null) {
      _courses.add(course);
      return true;
    }
    return false;
  }

  String get name {
    return _name;
  }

  set name(String newName) {
    _name = newName;
  }

  List<Course> get courses {
    return List.from(_courses);
  }
}

class Course {
  String _name;
  List<Chapter> _chapters;

  List<List<Subject>> get subjects {
    List<List<Subject>> list = List();
    for (Chapter chapter in _chapters) {
      list.addAll(chapter.subjects);
    }
    return list;
  }

  List<Chapter> get chapters {
    return List.from(_chapters);
  }

  String get name {
    return _name;
  }

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

  List<List<Subject>> get subjects {
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

  Subject(String name, Mastered mas) {
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
