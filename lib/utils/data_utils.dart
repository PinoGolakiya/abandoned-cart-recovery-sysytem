import 'package:intl/intl.dart';

// Custom data time formate
String formatDateTime(String rawDate) {
  final dateTime = DateTime.parse(rawDate);
  return DateFormat("dd MMM, hh:mm a").format(dateTime);
}
