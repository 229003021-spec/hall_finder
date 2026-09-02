/// A period/break/lunch slot in the daily timetable.
/// [id] is an int for real periods (1,2,3,4,6,7,8) or a String for
/// breaks/lunch ("b1", "ln", "b2") — mirrors the JS original.
class SlotInfo {
  final dynamic id;
  final String label;
  final String time;
  final int startH;
  final int startM;
  final int endH;
  final int endM;
  final String ptype; // 'period' | 'break' | 'lunch'

  const SlotInfo({
    required this.id,
    required this.label,
    required this.time,
    required this.startH,
    required this.startM,
    required this.endH,
    required this.endM,
    required this.ptype,
  });

  int get startMinutes => startH * 60 + startM;
  int get endMinutes => endH * 60 + endM;
}

/// Static info about a physical hall/room.
class HallInfo {
  final String courseName; // e.g. "I B.Tech C" or "—" if unassigned
  final String dept;
  final bool proj; // has projector
  final int floor;

  const HallInfo({
    required this.courseName,
    required this.dept,
    required this.proj,
    required this.floor,
  });
}

/// A single cell in a hall's weekly timetable.
class ScheduleEntry {
  final String type; // 'class' | 'lab' | 'free'
  final String? course; // course code, for class/lab
  final String? faculty; // faculty name(s), for class/lab
  final String? note; // free-text note, for free slots

  const ScheduleEntry({
    required this.type,
    this.course,
    this.faculty,
    this.note,
  });

  static const ScheduleEntry emptyFree = ScheduleEntry(type: 'free', note: '');
}
