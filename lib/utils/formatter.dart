import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}:${twoDigits(duration.inMilliseconds % 1000 ~/ 10)}";
}

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
}