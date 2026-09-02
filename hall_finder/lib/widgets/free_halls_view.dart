import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/helpers.dart';
import '../theme.dart';

class FreeHallsView extends StatelessWidget {
  final String day;
  final dynamic effectivePid;
  final dynamic curSid;
  final int floor;

  const FreeHallsView({
    super.key,
    required this.day,
    required this.effectivePid,
    required this.curSid,
    required this.floor,
  });

  @override
  Widget build(BuildContext context) {
    final slot = allSlots.where((s) => s.id == effectivePid).isEmpty
        ? null
        : allSlots.firstWhere((s) => s.id == effectivePid);
    final isRest = slot != null && (slot.ptype == 'break' || slot.ptype == 'lunch');
    final outside = effectivePid == null;

    final ids = floorHalls(floor);
    final halls = ids.map((hid) {
      final info = hallInfo[hid]!;
      final free = isRest || outside || isHallFree(hid, day, effectivePid);
      return _HallRow(id: hid, info: info, free: free, hasData: hasTimetable(hid));
    }).toList();

    final fp = halls.where((h) => h.free && h.info.proj).toList();
    final fn = halls.where((h) => h.free && !h.info.proj).toList();
    final busy = halls.where((h) => !h.free).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (outside)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.bgPanel,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: const [
                Text('🌙', style: TextStyle(fontSize: 28)),
                SizedBox(height: 6),
                Text('Outside College Hours', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('Select a period above to check availability', style: TextStyle(color: AppColors.textFaint, fontSize: 12)),
              ],
            ),
          ),
        if (isRest)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF120D03),
              border: Border.all(color: const Color(0xFF78350F)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${slot!.ptype == 'lunch' ? '🍱' : '☕'} ${slot.label} · All halls are free!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.amber, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        _HallGroup(
          title: 'Free · With Projector',
          icon: '📽️',
          fg: AppColors.tealLight,
          bg: const Color(0xFF042F2E),
          border: AppColors.teal,
          halls: fp,
        ),
        _HallGroup(
          title: 'Free · No Projector',
          icon: '🪑',
          fg: AppColors.blueLight,
          bg: const Color(0xFF172554),
          border: const Color(0xFF1E3A8A),
          halls: fn,
        ),
        if (!outside && !isRest && busy.isNotEmpty) ...[
          Row(
            children: [
              const Text('🔴 Occupied',
                  style: TextStyle(color: AppColors.redLight, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 1)),
              const Spacer(),
              _CountBadge(count: busy.length, fg: AppColors.redLight, bg: const Color(0xFF1A0505), border: const Color(0xFF7F1D1D)),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final h in busy) _BusyTile(id: h.id),
            ],
          ),
        ],
      ],
    );
  }
}

class _HallRow {
  final String id;
  final dynamic info;
  final bool free;
  final bool hasData;
  _HallRow({required this.id, required this.info, required this.free, required this.hasData});
}

class _HallGroup extends StatelessWidget {
  final String title;
  final String icon;
  final Color fg;
  final Color bg;
  final Color border;
  final List<_HallRow> halls;

  const _HallGroup({
    required this.title,
    required this.icon,
    required this.fg,
    required this.bg,
    required this.border,
    required this.halls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('$icon $title', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
              const Spacer(),
              _CountBadge(count: halls.length, fg: fg, bg: bg, border: border),
            ],
          ),
          const SizedBox(height: 7),
          if (halls.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgPanel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0F1A28)),
              ),
              child: const Text('None available', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final h in halls)
                  Container(
                    width: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.bgPanel,
                      border: Border.all(color: border.withOpacity(0.25)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Hall ${h.id}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 3),
                        _CountBadge(count: null, label: '✓ FREE', fg: const Color(0xFF34D399), bg: const Color(0xFF041A0E), border: const Color(0xFF065F46)),
                        if (!h.hasData)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text('No schedule', style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 9)),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BusyTile extends StatelessWidget {
  final String id;
  const _BusyTile({required this.id});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF060808),
          border: Border.all(color: const Color(0xFF0F1828)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hall $id', style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 3),
            const _CountBadge(count: null, label: '✗ BUSY', fg: AppColors.redLight, bg: Color(0xFF1A0505), border: Color(0xFF7F1D1D)),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int? count;
  final String? label;
  final Color fg;
  final Color bg;
  final Color border;

  const _CountBadge({this.count, this.label, required this.fg, required this.bg, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label ?? '$count', style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
