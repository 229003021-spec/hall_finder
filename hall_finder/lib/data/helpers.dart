import '../models/models.dart';
import 'constants.dart';
import 'data.dart';

/// Detects today's day code, falling back to MON on weekends.
String detectDay() {
  // DateTime.weekday: Mon=1 ... Sun=7
  const map = {1: 'MON', 2: 'TUE', 3: 'WED', 4: 'THU', 5: 'FRI', 6: 'SAT', 7: 'SUN'};
  final d = map[DateTime.now().weekday]!;
  return days.contains(d) ? d : 'MON';
}

/// Returns the id of the slot containing the current wall-clock time,
/// or null if outside all defined slots (e.g. after 5:15 PM).
dynamic getCurSlotId([DateTime? now]) {
  final n = now ?? DateTime.now();
  final m = n.hour * 60 + n.minute;
  for (final s in allSlots) {
    if (m >= s.startMinutes && m < s.endMinutes) return s.id;
  }
  return null;
}

/// Looks up the schedule entry for a hall/day/period, defaulting to free.
ScheduleEntry getEntry(String hallId, String day, int periodId) {
  return schedule[hallId]?[day]?[periodId] ?? ScheduleEntry.emptyFree;
}

bool hasTimetable(String hallId) => schedule.containsKey(hallId);

/// Rooms without timetable data are treated as free (no class scheduled).
bool isHallFree(String hallId, String day, dynamic slotId) {
  if (!schedule.containsKey(hallId)) return true;
  if (slotId is! int) return true;
  final e = getEntry(hallId, day, slotId);
  return e.type == 'free' || e.type == 'lab';
}

List<String> floorHalls(int floor) {
  final ids = hallInfo.keys.where((id) => hallInfo[id]!.floor == floor).toList();
  ids.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
  return ids;
}

String ordinal(int n) {
  switch (n) {
    case 1:
      return '1st';
    case 2:
      return '2nd';
    case 3:
      return '3rd';
    default:
      return '${n}th';
  }
}
