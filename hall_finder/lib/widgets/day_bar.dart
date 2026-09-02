import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../theme.dart';

class DayBar extends StatelessWidget {
  final String selDay;
  final ValueChanged<String> onSelDay;
  final Color color;

  const DayBar({
    super.key,
    required this.selDay,
    required this.onSelDay,
    this.color = AppColors.purple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080E1A),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          const Text('Day:', style: TextStyle(color: AppColors.textFaint, fontSize: 11)),
          const SizedBox(width: 4),
          ...days.map((d) {
            final sel = selDay == d;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: OutlinedButton(
                onPressed: () => onSelDay(d),
                style: OutlinedButton.styleFrom(
                  backgroundColor: sel ? color : Colors.transparent,
                  foregroundColor: sel ? Colors.white : AppColors.textMuted,
                  side: BorderSide(color: sel ? color : AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(dayShort[d]!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            );
          }),
          const Spacer(),
          const Text('IST · Auto', style: TextStyle(color: AppColors.textFaint, fontSize: 10)),
        ],
      ),
    );
  }
}
