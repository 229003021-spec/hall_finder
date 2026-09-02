import 'package:flutter/material.dart';
import '../theme.dart';

class LandingScreen extends StatelessWidget {
  final void Function(String role) onSelectRole;

  const LandingScreen({super.key, required this.onSelectRole});

  @override
  Widget build(BuildContext context) {
    final roles = [
      _RoleOption('dean', '👑', 'Dean', 'Full hall overview & schedules', AppColors.purple),
      _RoleOption('faculty', '🎓', 'Faculty', 'Your schedule & free halls', AppColors.teal),
      _RoleOption('student', '📚', 'Students', 'Find free halls instantly', AppColors.blue),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏫', style: TextStyle(fontSize: 52)),
                const SizedBox(height: 6),
                const Text('Hall Finder',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -1)),
                const SizedBox(height: 8),
                const Text('SASTRA Deemed University · SRC, Kumbakonam',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                const SizedBox(height: 3),
                const Text('Odd Semester 2026–27 · Floors 1 – 5',
                    style: TextStyle(color: AppColors.textFaint, fontSize: 12)),
                const SizedBox(height: 40),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    children: [
                      for (final r in roles) ...[
                        _RoleButton(option: r, onTap: () => onSelectRole(r.id)),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOption {
  final String id;
  final String emoji;
  final String label;
  final String desc;
  final Color color;
  _RoleOption(this.id, this.emoji, this.label, this.desc, this.color);
}

class _RoleButton extends StatelessWidget {
  final _RoleOption option;
  final VoidCallback onTap;

  const _RoleButton({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: option.color.withOpacity(0.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: option.color.withOpacity(0.16)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: option.color.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(option.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(option.desc, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Text('›', style: TextStyle(color: option.color, fontSize: 24, fontWeight: FontWeight.w200)),
            ],
          ),
        ),
      ),
    );
  }
}
