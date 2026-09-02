import 'package:flutter/material.dart';
import '../theme.dart';

class FloorPicker extends StatelessWidget {
  final int? selFloor;
  final ValueChanged<int> onSelFloor;
  final Color color;

  const FloorPicker({
    super.key,
    required this.selFloor,
    required this.onSelFloor,
    this.color = AppColors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('SELECT FLOOR',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1)),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 3,
          children: [
            for (final f in [1, 2, 3, 4, 5])
              _buildTile(f),
          ],
        ),
      ],
    );
  }

  Widget _buildTile(int f) {
    final sel = selFloor == f;
    return OutlinedButton(
      onPressed: () => onSelFloor(f),
      style: OutlinedButton.styleFrom(
        backgroundColor: sel ? color : AppColors.border,
        foregroundColor: sel ? Colors.white : const Color(0xFF64748B),
        side: BorderSide(color: sel ? color : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$f', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          if (sel) const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text('★', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
