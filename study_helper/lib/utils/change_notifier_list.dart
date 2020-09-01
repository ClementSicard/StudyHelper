import 'package:flutter/material.dart';

class ChangeNotifierList<E> with ChangeNotifier {
  List<E> _list;

  ChangeNotifierList(List<E> list) {
    _list = List.from(list);
  }

  ChangeNotifierList.from(List<E> list) {
    _list = List.from(list);
  }

  ChangeNotifierList.empty() {
    _list = List();
  }

  bool get isEmpty {
    return _list.isEmpty;
  }

  int get length {
    return _list.length;
  }

  ///returns a copy of the list
  List<E> get list {
    return _list;
  }

  ///add the given element to the list and notify listeners
  void add(E element) {
    _list.add(element);
    notifyListeners();
  }

  ///remove the given element from the list and notify listeners
  void remove(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  ///clear the list and notify listeners
  void clear() {
    _list.clear();
    notifyListeners();
  }

  void allAll(Iterable<E> iterable) {
    if (iterable != null) {
      _list.addAll(iterable);
      notifyListeners();
    }
  }

  void newList(Iterable<E> iterable) {
    assert(iterable != null);
    _list = List<E>.from(iterable);
    notifyListeners();
  }
}
