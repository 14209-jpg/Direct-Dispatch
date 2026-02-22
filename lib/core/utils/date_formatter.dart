import 'package:intl/intl.dart';

class DateFormatter {
  static String chatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat.jm().format(dt);
    if (diff.inDays == 1) return 'Yesterday ${DateFormat.jm().format(dt)}';
    if (diff.inDays < 7) return DateFormat('EEE h:mm a').format(dt);
    return DateFormat('MMM d, y').format(dt);
  }

  static String full(DateTime dt) =>
      DateFormat('MMM d, y – h:mm a').format(dt);
}