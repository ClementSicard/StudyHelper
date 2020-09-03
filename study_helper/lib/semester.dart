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
  List<List<Subject>> _subjects;

  List<List<Subject>> get subjects {
    return List.from(_subjects);
  }

  String get name {
    return _name;
  }

  set name(String newName) {
    _name = newName;
  }
}

class Subject {}
