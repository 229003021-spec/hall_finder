import 'package:flutter/material.dart';
import '../data/helpers.dart';
import '../theme.dart';

class FloorBar extends StatelessWidget {
  final int? selFloor;
  final ValueChanged<int> onSelFloor;

  const FloorBar({super.key, required this.selFloor, required this.onSelFloor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPanelAlt,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          const Text('Floor:', style: TextStyle(color: AppColors.textFaint, fontSize: 11)),
          for (final f in [1, 2, 3, 4, 5])
            _FloorChip(floor: f, selected: selFloor == f, onTap: () => onSelFloor(f)),
        ],
      ),
    );
  }
}

class _FloorChip extends StatelessWidget {
  final int floor;
  final bool selected;
  final VoidCallback onTap;

  const _FloorChip({required this.floor, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.purple : Colors.transparent,
        foregroundColor: selected ? Colors.white : AppColors.textMuted,
        side: BorderSide(color: selected ? AppColors.purple : AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${ordinal(floor)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          if (selected) const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text('★', style: TextStyle(color: AppColors.purpleLight, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
