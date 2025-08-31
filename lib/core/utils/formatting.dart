import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Formatting {
  static String currencyINR(num amount, {Locale? locale}) {
    final loc = locale ?? const Locale('en', 'IN');
    final fmt = NumberFormat.currency(locale: '${loc.languageCode}_${loc.countryCode}', symbol: '₹');
    return fmt.format(amount);
  }

  static String formatDate(DateTime date, {Locale? locale}) {
    final loc = locale ?? const Locale('en', 'IN');
    final fmt = DateFormat.yMMMd('${loc.languageCode}_${loc.countryCode}');
    return fmt.format(date);
  }
}
