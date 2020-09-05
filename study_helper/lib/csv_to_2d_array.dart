import 'dart:io';
import 'package:study_helper/semester.dart';

List<Chapter> CSVto2DArray(File csv, {String delimitator = ";"}) {
  if (csv == null)
    return null;
  else {
    List<String> contents = csv.readAsLinesSync();
    int nbOfChapters = contents[0].split(";").length;
    if (!checkCorrectCSV(contents, nbOfChapters)) {
      return null;
    } else {
      List<Chapter> chapters = List();
      List<String> firstLine = contents[0].split(delimitator);
      for (int i = 0; i < nbOfChapters; i++) {
        List<Subject> subList = List();
        for (int j = 0; j < contents.length; j++) {
          List<String> currentLine = contents[j].split(delimitator);
          // Initially all the subjects are poorly mastered
          subList.add(Subject(currentLine[i], Mastered.Poorly));
        }
        chapters.add(Chapter(firstLine[i], subList));
      }
      return chapters;
    }
  }
}

bool checkCorrectCSV(List<String> csv, int nbOfChapters,
    {String delimitator = ";"}) {
  for (String s in csv) {
    if (s.split(delimitator).length != nbOfChapters) {
      return false;
    }
  }
  return true;
}
