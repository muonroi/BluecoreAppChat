int getMonthAgo(DateTime dateTime) {
  DateTime currentDate = DateTime.now();

  int yearsDiff = currentDate.year - dateTime.year;
  int monthsDiff = currentDate.month - dateTime.month;

  return (yearsDiff * 12) + monthsDiff;
}
