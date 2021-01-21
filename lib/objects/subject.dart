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

  Mastered get mas {
    return _mas;
  }

  set name(String name) {
    _name = name;
  }
}

enum Mastered { Good, Moderately, Poorly }
