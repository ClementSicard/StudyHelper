import 'package:flutter/material.dart';

/// This class is usefull to use a Provider with a list and to be notified
/// if the list is changed. The list can only be change by the given methods
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

  /// Returns a copy of the list
  List<E> get list {
    return _list;
  }

  /// Add the given element to the list and notify listeners
  void add(E element) {
    _list.add(element);
    notifyListeners();
  }

  /// Remove the given element from the list and notify listeners
  void remove(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  /// Clear the list and notify listeners
  void clear() {
    _list.clear();
    notifyListeners();
  }

  /// Add all the given elements and notify listerners
  void addAll(Iterable<E> iterable) {
    if (iterable != null) {
      _list.addAll(iterable);
      notifyListeners();
    }
  }

  /// Erase the actual list and replace it with the new given elements, and then notify listeners
  void newList(Iterable<E> iterable) {
    assert(iterable != null);
    _list = List<E>.from(iterable);
    notifyListeners();
  }
}
