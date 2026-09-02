import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../theme.dart';

class PeriodSelector extends StatelessWidget {
  final dynamic selPid;
  final dynamic curSid;
  final bool isLive;
  final ValueChanged<dynamic> onSelPid;
  final ValueChanged<bool> onIsLive;

  const PeriodSelector({
    super.key,
    required this.selPid,
    required this.curSid,
    required this.isLive,
    required this.onSelPid,
    required this.onIsLive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgPanel,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('PERIOD FILTER',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final nl = !isLive;
                  onIsLive(nl);
                  if (nl && curSid != null) onSelPid(curSid);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLive ? const Color(0xFF052E16) : AppColors.border,
                    border: Border.all(color: isLive ? const Color(0xFF166534) : AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLive ? AppColors.green : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(isLive ? '🔴 Live' : '⏸ Manual',
                          style: TextStyle(
                              color: isLive ? const Color(0xFF4ADE80) : const Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (final sl in allSlots) _buildChip(sl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(SlotInfo sl) {
    final isSel = selPid == sl.id;
    final isCur = curSid == sl.id;
    final isSpec = sl.ptype == 'break' || sl.ptype == 'lunch';
    return GestureDetector(
      onTap: () {
        onSelPid(sl.id);
        onIsLive(false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSel
                ? (isSpec ? const Color(0xFF78350F) : AppColors.teal)
                : (isSpec ? const Color(0xFF292215) : AppColors.border),
          ),
          color: isSel
              ? (isSpec ? const Color(0xFF1C1208) : const Color(0xFF042F2E))
              : (isSpec ? const Color(0xFF080604) : AppColors.border),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              sl.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSel
                    ? (isSpec ? AppColors.amber : AppColors.tealLight)
                    : (isSpec ? const Color(0xFF4B3000) : const Color(0xFF475569)),
              ),
            ),
            if (isCur)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
