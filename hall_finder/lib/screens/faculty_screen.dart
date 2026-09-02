import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/day_bar.dart';
import '../widgets/floor_picker.dart';
import '../widgets/free_halls_view.dart';
import '../widgets/period_selector.dart';

class FacultyScreen extends StatefulWidget {
  final String selDay;
  final ValueChanged<String> onSelDay;
  final DateTime now;
  final dynamic curSid;
  final dynamic selPid;
  final ValueChanged<dynamic> onSelPid;
  final bool pidLive;
  final ValueChanged<bool> onPidLive;
  final dynamic effPid;
  final VoidCallback onLogout;

  const FacultyScreen({
    super.key,
    required this.selDay,
    required this.onSelDay,
    required this.now,
    required this.curSid,
    required this.selPid,
    required this.onSelPid,
    required this.pidLive,
    required this.onPidLive,
    required this.effPid,
    required this.onLogout,
  });

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  int? selFloor;

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
                      const Text('SRC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.teal, letterSpacing: 3)),
                      Text(_timeStr, style: const TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  const Spacer(),
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
            DayBar(selDay: widget.selDay, onSelDay: widget.onSelDay, color: AppColors.teal),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF041A16),
                          border: Border.all(color: AppColors.teal),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: const [
                            Text('🚧', style: TextStyle(fontSize: 30)),
                            SizedBox(height: 6),
                            Text('Personal Schedule',
                                style: TextStyle(color: AppColors.tealLight, fontSize: 17, fontWeight: FontWeight.w800)),
                            SizedBox(height: 6),
                            Text('Faculty ID linking coming soon. Your HOD will configure your access.',
                                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('HALL AVAILABILITY', style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 11, letterSpacing: 1)),
                      ),
                      PeriodSelector(
                        selPid: widget.selPid,
                        curSid: widget.curSid,
                        isLive: widget.pidLive,
                        onSelPid: widget.onSelPid,
                        onIsLive: widget.onPidLive,
                      ),
                      FloorPicker(selFloor: selFloor, onSelFloor: (f) => setState(() => selFloor = f), color: AppColors.teal),
                      const SizedBox(height: 14),
                      if (selFloor == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Select a floor above', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
                        )
                      else
                        FreeHallsView(day: widget.selDay, effectivePid: widget.effPid, curSid: widget.curSid, floor: selFloor!),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
