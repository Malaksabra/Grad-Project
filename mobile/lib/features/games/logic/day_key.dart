/// The calendar day of [moment] as text, like "2026-11-07". Used to know if
/// the child already finished the game today.
String dayKey(DateTime moment) {
  final month = moment.month.toString().padLeft(2, '0');
  final day = moment.day.toString().padLeft(2, '0');
  return '${moment.year}-$month-$day';
}
