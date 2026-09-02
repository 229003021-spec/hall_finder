import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../data/data.dart';
import '../data/helpers.dart';
import '../models/models.dart';
import '../theme.dart';

class SchedulePanel extends StatefulWidget {
  final String hallId;
  final String day;
  final dynamic curSlotId;

  const SchedulePanel({super.key, required this.hallId, required this.day, required this.curSlotId});

  @override
  State<SchedulePanel> createState() => _SchedulePanelState();
}

class _SchedulePanelState extends State<SchedulePanel> {
  int? expandedPid;

  @override
  void didUpdateWidget(covariant SchedulePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hallId != widget.hallId) expandedPid = null;
  }

  @override
  Widget build(BuildContext context) {
    final hall = hallInfo[widget.hallId]!;
    final lunchSlot = allSlots.firstWhere((s) => s.ptype == 'lunch');
    final periodSlots = allSlots.where((s) => s.ptype == 'period').toList();

    if (!hasTimetable(widget.hallId)) {
      return _NoTimetableCard(hallId: widget.hallId, hall: hall);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF0D1828))),
            ),
            child: Row(
              children: [
                Text(dayFull[widget.day]!,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                const Text('·', style: TextStyle(color: AppColors.textFaint)),
                const SizedBox(width: 8),
                Text(hall.courseName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(width: 8),
                const Text('·', style: TextStyle(color: AppColors.textFaint)),
                const SizedBox(width: 8),
                Text('Dept. of ${hall.dept}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const Spacer(),
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                const Text('Live', style: TextStyle(color: AppColors.green, fontSize: 11)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Tap a period row to reveal the professor name below it.',
                style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 11, fontStyle: FontStyle.italic)),
          ),
          // Rows
          for (final slot in periodSlots) ...[
            if (slot.id == 6)
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E0902),
                  border: Border.all(color: const Color(0xFF1F1505)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('🍱', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    const Text('Lunch Break', style: TextStyle(color: Color(0xFF92400E), fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 12),
                    Text(lunchSlot.time, style: const TextStyle(color: Color(0xFF3A2002), fontSize: 12)),
                    const Spacer(),
                    const Text('All halls free', style: TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            _PeriodRow(
              hallId: widget.hallId,
              day: widget.day,
              slot: slot,
              isCur: widget.curSlotId == slot.id,
              isExpanded: expandedPid == slot.id,
              onTap: () => setState(() => expandedPid = expandedPid == slot.id ? null : slot.id as int),
            ),
            const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }
}

class _NoTimetableCard extends StatelessWidget {
  final String hallId;
  final HallInfo hall;

  const _NoTimetableCard({required this.hallId, required this.hall});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.bgPanel,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(hall.proj ? '📽️' : '🏫', style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text('Hall $hallId',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('${ordinal(hall.floor)} Floor', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: hall.proj ? const Color(0xFF042F2E) : AppColors.border,
                border: Border.all(color: hall.proj ? AppColors.teal : const Color(0xFF334155)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(hall.proj ? '📽️' : '🪑', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(hall.proj ? 'Projector Available' : 'No Projector',
                      style: TextStyle(
                          color: hall.proj ? AppColors.tealLight : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('📋 No timetable data available for this hall yet.',
                style: TextStyle(color: Color(0xFF334155), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PeriodRow extends StatelessWidget {
  final String hallId;
  final String day;
  final SlotInfo slot;
  final bool isCur;
  final bool isExpanded;
  final VoidCallback onTap;

  const _PeriodRow({
    required this.hallId,
    required this.day,
    required this.slot,
    required this.isCur,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final e = getEntry(hallId, day, slot.id as int);
    final isFree = e.type == 'free' || e.type == 'lab';

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isCur ? const Color(0xFF051210) : (isExpanded ? const Color(0xFF0A0F1C) : AppColors.bgCard),
              border: Border.all(color: isCur ? AppColors.green : (isExpanded ? const Color(0xFF3730A3) : AppColors.borderDim), width: 1.5),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(12),
                bottom: isExpanded ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isCur) Container(width: 4, color: AppColors.green),
                  // Period label
                  Container(
                    width: 64,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Color(0xFF0D1828))),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(slot.label,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: isCur ? AppColors.green : (isExpanded ? const Color(0xFF818CF8) : const Color(0xFF1E3A5F)))),
                        if (isCur)
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                      ],
                    ),
                  ),
                  // Time
                  Container(
                    width: 130,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Color(0xFF0D1828))),
                    ),
                    child: Text(slot.time, style: const TextStyle(color: Color(0xFF334155), fontSize: 12)),
                  ),
                  // Course / status
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _statusText(e),
                      ),
                    ),
                  ),
                  // Status badge + expand hint
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(isExpanded ? '▲' : '▼', style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isFree ? const Color(0xFF041A0E) : const Color(0xFF150404),
                            border: Border.all(color: isFree ? const Color(0xFF0D4228) : const Color(0xFF4A0808)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(isFree ? 'FREE' : 'BUSY',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isFree ? AppColors.green : AppColors.redLight)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF080D1C),
              border: Border.all(color: const Color(0xFF3730A3), width: 1.5),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: _expandedContent(e, isCur),
          ),
      ],
    );
  }

  Widget _statusText(ScheduleEntry e) {
    if (e.type == 'class') {
      return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(color: isCur ? const Color(0xFFC7D2FE) : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
          children: [
            TextSpan(text: '${e.course}  '),
            TextSpan(text: courseNames[e.course] ?? '', style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 11)),
          ],
        ),
      );
    }
    if (e.type == 'lab') {
      return const Text('🔬 Lab – Hall Free', style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.w600));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: AppColors.green, fontSize: 13, fontWeight: FontWeight.w600),
        children: [
          const TextSpan(text: '✓ Hall Free '),
          if (e.note != null && e.note!.isNotEmpty)
            TextSpan(text: '· ${e.note}', style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _expandedContent(ScheduleEntry e, bool isCur) {
    if (e.type == 'class') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PROFESSOR', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(e.faculty ?? '', style: TextStyle(color: isCur ? const Color(0xFF4ADE80) : const Color(0xFFA5B4FC), fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      );
    }
    if (e.type == 'lab') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LAB INCHARGE', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(e.faculty ?? '', style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(courseNames[e.course] ?? e.course ?? '', style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 11)),
        ],
      );
    }
    final note = e.note != null && e.note!.isNotEmpty ? ' · ${e.note}' : '';
    return Text('✓ No class — hall is free$note', style: const TextStyle(color: AppColors.green, fontSize: 13, fontWeight: FontWeight.w600));
  }
}
