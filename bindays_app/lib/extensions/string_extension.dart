extension StringExtension on String {
  String capitaliseEveryWord() {
    return split(" ").map((word) => word.capitaliseFirstLetter()).join(" ");
  }

  String capitaliseFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
