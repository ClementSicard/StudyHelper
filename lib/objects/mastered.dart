class Mastered {
  final int value;

  const Mastered(this.value);

  static const Mastered Poorly = Mastered(0);
  static const Mastered Moderately = Mastered(1);
  static const Mastered Good = Mastered(2);
  static const Mastered Expert = Mastered(3);

  @override
  String toString() {
    String toReturn = "";
    switch (value) {
      case 0:
        toReturn = "Poorly";
        break;
      case 1:
        toReturn = "Moderately";
        break;
      case 2:
        toReturn = "Good";
        break;
      case 3:
        return "Expert";
        break;
      default:
        break;
    }
    return toReturn;
  }
}
