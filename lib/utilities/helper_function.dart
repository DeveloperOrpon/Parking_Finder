import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
    DateFormat(pattern).format(dt);

getMessageTimeFormat(DateTime dt, {String pattern = 'HH:mm a'}) =>
    DateFormat(pattern).format(dt);
getNotificationTimeFormat(DateTime dt,
        {String pattern = 'dd/MM/yyyy : HH:mm a'}) =>
    DateFormat(pattern).format(dt);

getJoinTimeFormattedDate(String stDate) {
  var newStr = '${stDate.substring(0, 10)} ${stDate.substring(11, 23)}';
  DateTime dt = DateTime.parse(newStr);
  return DateFormat("HH:mm EEE, d MMM yyyy ").format(dt);
}

dateFormattedTimestamp(Timestamp st) {
  return DateFormat("HH:mm EEE, d MMM yyyy ")
      .format(DateTime.fromMillisecondsSinceEpoch(st.millisecondsSinceEpoch));
}

String ordinal(int number) {
  if (number == 0) {
    return 'GF';
  }
  if (!(number >= 1 && number <= 100)) {
    //here you change the range
    throw Exception('Invalid number');
  }

  if (number >= 11 && number <= 13) {
    return 'th';
  }

  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String getParkingTime(String duration) {
  int timeSec = num.parse(duration).toInt();
  Duration timeDuration = Duration(milliseconds: timeSec);
  int centiseconds = timeDuration.inMilliseconds ~/ 10;
  int seconds = timeDuration.inSeconds;
  int minutes = timeDuration.inMinutes;
  int hours = timeDuration.inHours;
  int day = timeDuration.inDays;
  if (day > 0) {
    return "$day Days";
  } else if (hours > 0) {
    return "$hours Hours ";
  } else {
    return "$minutes Minutes";
  }
}
