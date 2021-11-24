import 'package:instant/instant.dart';
import 'package:intl/intl.dart';

import '../constants/strings.dart' as AppStrings;

String formatDate(String pattern, String dateToFormat) {
  return DateFormat(pattern).format(dateTimeToOffset(
      offset: double.parse(AppStrings.colombiaUtcTimeZoneOffset),
      datetime: DateTime.parse(dateToFormat)));
}

String timeDifference(String date1, String date2) {
  NumberFormat formatter = NumberFormat();
  formatter.minimumIntegerDigits = 2;

  String hours = formatter.format(
      DateTime.parse(date2).difference(DateTime.parse(date1)).inHours % 24);

  String minutes = formatter.format(
      DateTime.parse(date2).difference(DateTime.parse(date1)).inMinutes % 60);

  String seconds = formatter.format(
      DateTime.parse(date2).difference(DateTime.parse(date1)).inSeconds % 60);

  return '$hours:$minutes:$seconds';
}
