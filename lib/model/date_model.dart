class MyDate {
  static DateTime getNow() {
    return DateTime.now();
  }

  static DateTime getDayAfterTomorrow() {
    return DateTime.now().add(const Duration(days: 2));
  }
}
