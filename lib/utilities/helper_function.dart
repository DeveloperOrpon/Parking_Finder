import 'package:intl/intl.dart';

getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
    DateFormat(pattern).format(dt);

getJoinTimeFormattedDate(String stDate) {
  var newStr = '${stDate.substring(0, 10)} ${stDate.substring(11, 23)}';
  DateTime dt = DateTime.parse(newStr);
  return DateFormat("HH:mm EEE, d MMM yyyy ").format(dt);
}
