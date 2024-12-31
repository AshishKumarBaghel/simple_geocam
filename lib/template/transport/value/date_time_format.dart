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

/*
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDateTime(DateTime dateTime, DateTimeFormat format) {
    switch (format) {
      case DateTimeFormat.yyyyMMdd_hmma:
        return DateFormat("yyyy/MM/dd h:mm a").format(dateTime);
      case DateTimeFormat.ddMMMyyyy:
        return DateFormat("dd, MMM yyyy").format(dateTime);
      case DateTimeFormat.ddMMMyyyy_hmm:
        return DateFormat("dd, MMM yyyy h:mm").format(dateTime);
      case DateTimeFormat.ddMMMMyyyy_hmma:
        return DateFormat("dd, MMMM yyyy h:mm a").format(dateTime);
      case DateTimeFormat.EEEE_ddthMMMyyyy:
        return DateFormat("EEEE, dd'th' MMM yyyy").format(dateTime);
      case DateTimeFormat.EEEE_ddthMMMMyyyy:
        return DateFormat("EEEE, dd'th' MMMM yyyy").format(dateTime);
      case DateTimeFormat.EEEE_ddthMMMMyyyy_hmm:
        return DateFormat("EEEE, dd'th' MMMM yyyy h:mm").format(dateTime);
      case DateTimeFormat.EEEE_ddthMMMMyyyy_hmma:
        return DateFormat("EEEE, dd'th' MMMM yyyy h:mm a").format(dateTime);
      case DateTimeFormat.ddMMyyyy_hmma:
        return DateFormat("dd/MM/yyyy h:mm a").format(dateTime);
      case DateTimeFormat.MMddyyyy:
        return DateFormat("MM/dd/yyyy").format(dateTime);
      case DateTimeFormat.MMddyyyy_hmma:
        return DateFormat("MM/dd/yyyy h:mm a").format(dateTime);
      case DateTimeFormat.yyyyMMdd:
        return DateFormat("yyyy/MM/dd").format(dateTime);
      case DateTimeFormat.customGMT:
        return DateFormat("MM/dd/yyyy hh:mm a 'GMT' +05:30").format(dateTime);
      default:
        return DateFormat("yyyy/MM/dd").format(dateTime); // Default format
    }
  }
}

 */
