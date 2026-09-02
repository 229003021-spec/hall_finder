import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../data/data.dart';
import '../data/helpers.dart';
import '../theme.dart';
import '../widgets/floor_picker.dart';
import '../widgets/free_halls_view.dart';
import '../widgets/period_selector.dart';

class StudentScreen extends StatefulWidget {
  final String selDay;
  final DateTime now;
  final dynamic curSid;
  final dynamic selPid;
  final ValueChanged<dynamic> onSelPid;
  final bool pidLive;
  final ValueChanged<bool> onPidLive;
  final dynamic effPid;
  final VoidCallback onHome;

  const StudentScreen({
    super.key,
    required this.selDay,
    required this.now,
    required this.curSid,
    required this.selPid,
    required this.onSelPid,
    required this.pidLive,
    required this.onPidLive,
    required this.effPid,
    required this.onHome,
  });

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int? selFloor;

  String get _timeStr {
    final h = widget.now.hour % 12 == 0 ? 12 : widget.now.hour % 12;
    final m = widget.now.minute.toString().padLeft(2, '0');
    final ampm = widget.now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final freeCount = selFloor != null
        ? floorHalls(selFloor!).where((hid) => isHallFree(hid, widget.selDay, widget.effPid) || widget.effPid is! int).length
        : 0;
    final curSlot = allSlots.where((s) => s.id == widget.effPid).isEmpty
        ? null
        : allSlots.firstWhere((s) => s.id == widget.effPid);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0C3255), Color(0xFF1D4ED8), Color(0xFF0D9488)],
                  stops: [0, 0.6, 1],
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('🏫 Hall Finder',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                              const SizedBox(height: 2),
                              Text('SASTRA SRC · ${dayFull[widget.selDay]}',
                                  style: const TextStyle(color: Color(0x8CFFFFFF), fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_timeStr, style: const TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                            const SizedBox(height: 5),
                            TextButton(
                              onPressed: widget.onHome,
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0x40000000),
                                foregroundColor: const Color(0x99FFFFFF),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              ),
                              child: const Text('← Home', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0x38000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        spacing: 28,
                        runSpacing: 8,
                        children: [
                          _StatBlock(label: 'Free Now', value: selFloor != null ? '$freeCount' : '—'),
                          _StatBlock(label: 'Period', value: curSlot?.label ?? '—', valueColor: const Color(0xFFBAE6FD), valueSize: 14),
                          _StatBlock(label: 'Time', value: curSlot?.time ?? 'Outside hrs', valueColor: const Color(0xFFBAE6FD), valueSize: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PeriodSelector(
                        selPid: widget.selPid,
                        curSid: widget.curSid,
                        isLive: widget.pidLive,
                        onSelPid: widget.onSelPid,
                        onIsLive: widget.onPidLive,
                      ),
                      FloorPicker(selFloor: selFloor, onSelFloor: (f) => setState(() => selFloor = f), color: AppColors.blue),
                      const SizedBox(height: 14),
                      if (selFloor == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            children: const [
                              Text('🏢', style: TextStyle(fontSize: 36)),
                              SizedBox(height: 10),
                              Text('Select a floor above', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F))),
                            ],
                          ),
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

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final double valueSize;

  const _StatBlock({required this.label, required this.value, this.valueColor = Colors.white, this.valueSize = 22});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Color(0x73FFFFFF), fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.w900, color: valueColor)),
      ],
    );
  }
}
