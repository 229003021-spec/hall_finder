import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../data/data.dart';
import '../data/helpers.dart';
import '../theme.dart';
import '../widgets/day_bar.dart';
import '../widgets/floor_bar.dart';
import '../widgets/schedule_panel.dart';

class DeanScreen extends StatefulWidget {
  final String selDay;
  final ValueChanged<String> onSelDay;
  final DateTime now;
  final dynamic curSid;
  final VoidCallback onLogout;

  const DeanScreen({
    super.key,
    required this.selDay,
    required this.onSelDay,
    required this.now,
    required this.curSid,
    required this.onLogout,
  });

  @override
  State<DeanScreen> createState() => _DeanScreenState();
}

class _DeanScreenState extends State<DeanScreen> {
  int? selFloor;
  String? selRoom;

  String get _timeStr {
    final h = widget.now.hour % 12 == 0 ? 12 : widget.now.hour % 12;
    final m = widget.now.minute.toString().padLeft(2, '0');
    final s = widget.now.second.toString().padLeft(2, '0');
    final ampm = widget.now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m:$s $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.bgPanel,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SRC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.purple, letterSpacing: 3)),
                      Text(_timeStr, style: const TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text(_dateStr(widget.now), style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Viewing', style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 11)),
                      Text(dayFull[widget.selDay]!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.purpleLight)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: widget.onLogout,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.border,
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
            DayBar(selDay: widget.selDay, onSelDay: (d) {
              widget.onSelDay(d);
            }, color: AppColors.purple),
            FloorBar(
              selFloor: selFloor,
              onSelFloor: (f) => setState(() {
                selFloor = f;
                selRoom = null;
              }),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LEFT — room list
                  Container(
                    width: 180,
                    color: AppColors.bgPanelAlt,
                    child: selFloor == null
                        ? const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text('Pick a floor\nabove',
                                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textFaint, fontSize: 12, height: 1.5)),
                          )
                        : _RoomList(
                            floor: selFloor!,
                            selRoom: selRoom,
                            day: widget.selDay,
                            curSid: widget.curSid,
                            onSelect: (hid) => setState(() => selRoom = selRoom == hid ? null : hid),
                          ),
                  ),
                  // RIGHT — schedule panel
                  Expanded(
                    child: Container(
                      color: AppColors.bg,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: selRoom == null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Opacity(opacity: 0.1, child: const Text('📋', style: TextStyle(fontSize: 52))),
                                  const SizedBox(height: 10),
                                  const Text('Select a hall from the left panel',
                                      style: TextStyle(color: Color(0xFF0F1E30), fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  const Text('The schedule will appear here', style: TextStyle(color: Color(0xFF0A1420), fontSize: 13)),
                                ],
                              ),
                            )
                          : SchedulePanel(hallId: selRoom!, day: widget.selDay, curSlotId: widget.curSid),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _dateStr(DateTime d) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _RoomList extends StatelessWidget {
  final int floor;
  final String? selRoom;
  final String day;
  final dynamic curSid;
  final ValueChanged<String> onSelect;

  const _RoomList({
    required this.floor,
    required this.selRoom,
    required this.day,
    required this.curSid,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final ids = floorHalls(floor);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text('${ordinal(floor)} Floor · ${ids.length} rooms',
              style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 10, letterSpacing: 1)),
        ),
        for (final hid in ids) _RoomTile(
          hallId: hid,
          isSel: selRoom == hid,
          day: day,
          curSid: curSid,
          onTap: () => onSelect(hid),
        ),
      ],
    );
  }
}

class _RoomTile extends StatelessWidget {
  final String hallId;
  final bool isSel;
  final String day;
  final dynamic curSid;
  final VoidCallback onTap;

  const _RoomTile({required this.hallId, required this.isSel, required this.day, required this.curSid, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final h = hallInfo[hallId]!;
    final hasTt = hasTimetable(hallId);
    final curE = (curSid is int && hasTt) ? getEntry(hallId, day, curSid as int) : null;
    final curF = curE != null && curE.type == 'class' ? curE.faculty : null;
    final occ = curE != null && curE.type == 'class';

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: isSel ? const Color(0xFF120A2E) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSel ? const Color(0xFF5B21B6) : AppColors.borderDim),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasTt ? (occ ? AppColors.red : AppColors.green) : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text('Hall $hallId', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
                    const Spacer(),
                    Text(h.proj ? '📽️' : '🪑', style: const TextStyle(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: hasTt
                      ? Text(
                          curF != null ? '👤 $curF' : '✓ Free now',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: curF != null ? (isSel ? const Color(0xFFC4B5FD) : const Color(0xFF4ADE80)) : AppColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Text('No schedule', style: TextStyle(color: Color(0xFF1E293B), fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
