import 'package:intl/intl.dart';

enum DateTimeFormat {
  shortDateTime12Hour("dd/MM/yyyy h:mm a"), // "dd/MM/yyyy h:mm a"
  usDateFormat("MM/dd/yyyy"),              // "MM/dd/yyyy"
  usDateTime12Hour("MM/dd/yyyy h:mm a"),   // "MM/dd/yyyy h:mm a"
  fullDate("yyyy/MM/dd"),                  // "yyyy/MM/dd"
  fullDateTime12Hour("yyyy/MM/dd h:mm a"), // "yyyy/MM/dd h:mm a"
  shortDateWithComma("dd, MMM yyyy"),      // "dd, MMM yyyy"
  shortDateTime24Hour("dd, MMM yyyy h:mm"),// "dd, MMM yyyy h:mm"
  longDateTime12Hour("dd, MMMM yyyy h:mm a"), // "dd, MMMM yyyy h:mm a"
  weekdayWithShortDate("EEEE, dd'th' MMM yyyy"), // "EEEE, dd'th' MMM yyyy"
  weekdayWithLongDateTime("EEEE, dd'th' MMMM yyyy h:mm"), // "EEEE, dd'th' MMMM yyyy h:mm"
  weekdayWithLongDateTime12("EEEE, dd'th' MMMM yyyy h:mm a"); // "EEEE, dd'th' MMMM yyyy h:mm a"

  final String pattern;

  const DateTimeFormat(this.pattern);

  // Lazy initialization of DateFormat
  DateFormat get dateFormat => DateFormat(pattern);

  String format(DateTime dateTime) {
    return dateFormat.format(dateTime);
  }
}
