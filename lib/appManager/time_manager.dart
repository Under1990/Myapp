import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

///เลือกเวลาในการแสดงผลกราฟ
class TimeManager {
  static List<String> reducedTimesSixty = [];
  static List<String> reducedTwentyHour = [];
  static List<String> reducedSevenDays = [];
  static List<String> reducedThirtyDays = [];
  static String timeTriggerValue = "";
  static String monthDisplay = "";

  static timeSixtyRange() {
    DateTime currentTime = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 12; i++) {
      String formattedTime = DateFormat('HH:mm a').format(currentTime);
      currentTime = currentTime.subtract(Duration(minutes: 5));
      reducedTimesSixty.add(formattedTime);
    }
  }

  static timeTwentyHour() {
    DateTime currentTime = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 24; i++) {
      String formattedTime = DateFormat('HH:00 a').format(currentTime);
      currentTime = currentTime.subtract(Duration(hours: 1));
      reducedTwentyHour.add(formattedTime);
    }
  }

  static timeSevenDays() {
    DateTime currentDate = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 7; i++) {
      String formattedTime =
          '${monthsName(currentDate)} ${currentDate.day.toString().padLeft(2, '0')}';
      currentDate = currentDate.subtract(Duration(days: 1));
      reducedSevenDays.add(formattedTime);
    }
  }

  static timeThirtyDays() {
    DateTime currentDate = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 31; i++) {
      String formattedTime =
          '${monthsName(currentDate)} ${currentDate.day.toString().padLeft(2, '0')}';
      currentDate = currentDate.subtract(Duration(days: 2));
      reducedThirtyDays.add(formattedTime);
    }
  }

  static monthsName(DateTime currentDate) {
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    switch (currentDate.month.toString().padLeft(2, '0')) {
      case "02":
        return months[1];
      case "03":
        return months[2];
      case "04":
        return months[3];
      case "05":
        return months[4];
      case "06":
        return months[5];
      case "07":
        return months[6];
      case "08":
        return months[7];
      case "09":
        return months[8];
      case "10":
        return months[9];
      case "11":
        return months[10];
      case "12":
        return months[11];
      default:
        return months[0];
    }
  }

  static timeTrigger() {
    DateTime currentTime = tz.TZDateTime.now(tz.local);
    String formattedTime = DateFormat('HH:mm a').format(currentTime);
    timeTriggerValue = formattedTime;
  }
}
