import 'dart:io';
import 'package:study_helper/semester.dart';

List<List<Subject>> CSVto2DArray(File csv) {
  if (csv == null)
    return null;
  else {
    List<String> contents = csv.readAsLinesSync();
  }
}
