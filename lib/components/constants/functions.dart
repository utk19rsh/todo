import 'package:todo/components/constants/constants.dart';

class Convertors {
  String _padString(int input, {int? length}) {
    if (input < 10) {
      return input.toString().padLeft(length ?? 2, "0");
    }
    return input.toString();
  }

  String formatDate(DateTime time, {bool? withWeekDay}) {
    String dayOfWeek = listOfWeekdays[time.weekday];
    String date = _padString(time.day);
    String month = listOfMonths[time.month].substring(0, 3);
    String year = time.year.toString();
    return "$dayOfWeek, $date $month $year";
  }

  String formatDateMDY(DateTime time, {bool? withWeekDay}) {
    String date = _padString(time.day);
    String month = listOfMonths[time.month].substring(0, 3);
    String year = time.year.toString();
    return "$month $date, $year";
  }

  String formatDateDM(DateTime time, {bool? withWeekDay}) {
    String date = _padString(time.day);
    String month = listOfMonths[time.month].substring(0, 3);
    return "$date $month";
  }

  String formatTime(DateTime time) {
    String hour = _padString(time.hour % 12),
        min = _padString(time.minute),
        suffix = time.hour > 11 ? "AM" : "PM";
    return "$hour:$min $suffix";
  }

  String formatTDMD(DateTime time) {
    String dayOfWeek = listOfWeekdays[time.weekday];
    String date = _padString(time.day);
    String month = listOfMonths[time.month].substring(0, 3);
    return "${formatTime(time)} $date $month, $dayOfWeek.";
  }

}

class CheckEquality {
  bool sameDate(DateTime a, DateTime b) {
    if (a.year == b.year && a.month == b.month && a.day == b.day) {
      return true;
    }
    return false;
  }

  bool sameTime(DateTime a, DateTime b) {
    if (a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute) {
      return true;
    }
    return false;
  }
}
