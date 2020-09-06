import 'dart:io';
import 'package:study_helper/objects/semester.dart';

Future<List<Chapter>> csvTo2DArray(File csv, {String delimiter = ";"}) async {
  if (csv == null) {
    print("CSV file is null\n");
    return null;
  } else {
    List<String> contents = await csv.readAsLines();
    int nbOfChapters = contents[0].split(";").length;
    if (!_checkCorrectCSV(contents, nbOfChapters)) {
      return null;
    } else {
      List<Chapter> chapters = List();
      List<String> firstLine = contents[0].split(delimiter);
      for (int i = 0; i < nbOfChapters; i++) {
        List<Subject> subList = List();
        for (int j = 0; j < contents.length; j++) {
          List<String> currentLine = contents[j].split(delimiter);
          // Initially all the subjects are all poorly mastered
          subList.add(Subject(currentLine[i]));
        }
        chapters.add(Chapter(firstLine[i], subList));
      }
      return chapters;
    }
  }
}

Future<void> arrayToCSV(List<Chapter> chapters, File csv,
    {String delimiter = ";"}) async {
  int max = _maxSubjects(chapters);
  List<String> strings = List();

  // Initialize the list of strings to the max number of subjects
  for (int i = 0; i < max; i++) {
    strings.add("");
  }

  // Add the names of the chapters on top
  String firstLine = "";
  for (Chapter chapter in chapters) {
    firstLine += chapter.name + delimiter;
  }
  strings.add(firstLine);

  // For each chapter, add subject if there is any in it, otherwise add empty string
  for (int i = 0; i < max; i++) {
    String currentLine = "";
    for (Chapter chapter in chapters) {
      currentLine +=
          chapter.subjects.length > i ? chapter.subjects[i] : "" + delimiter;
    }
    strings.add(currentLine);
  }

  // Join all the lines into one big, separated by \n characters, and then write into the file
  String content = strings.join("\n");
  await csv.writeAsString(content);
}

/*******************************

            HELPERS

*******************************/

int _maxSubjects(List<Chapter> chapters) {
  int currentMax = 0;
  for (Chapter chapter in chapters) {
    int nbOfSubjects = chapter.subjects.length;
    if (nbOfSubjects > currentMax) {
      currentMax = nbOfSubjects;
    }
  }
  return currentMax;
}

bool _checkCorrectCSV(List<String> csv, int nbOfChapters,
    {String delimiter = ";"}) {
  for (String line in csv) {
    if (line.split(delimiter).length != nbOfChapters) {
      return false;
    }
  }
  return true;
}
