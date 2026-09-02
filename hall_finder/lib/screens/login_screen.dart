import 'package:flutter/material.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'dean' | 'faculty'
  final bool Function(String passkey) tryLogin; // returns true on success
  final VoidCallback onBack;

  const LoginScreen({super.key, required this.role, required this.tryLogin, required this.onBack});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  bool _showPk = false;
  bool _err = false;

  void _submit() {
    final ok = widget.tryLogin(_controller.text);
    setState(() => _err = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.role == 'dean' ? AppColors.purple : AppColors.teal;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.bgPanel,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: widget.onBack,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: AppColors.textMuted),
                      child: const Text('‹ Back', style: TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text(widget.role == 'dean' ? '👑' : '🎓', style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 8),
                          Text(widget.role == 'dean' ? 'Dean Login' : 'Faculty Login',
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          const Text('Enter your passkey to continue', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _controller,
                      obscureText: !_showPk,
                      onChanged: (_) => setState(() => _err = false),
                      onSubmitted: (_) => _submit(),
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Enter passkey...',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: AppColors.border,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: _err ? AppColors.red : AppColors.border, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: _err ? AppColors.red : AppColors.border, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: _err ? AppColors.red : col, width: 1.5),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _showPk = !_showPk),
                          icon: Text(_showPk ? '🙈' : '👁️', style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    if (_err)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('❌ Incorrect passkey. Try again.',
                            textAlign: TextAlign.center, style: TextStyle(color: AppColors.red, fontSize: 13)),
                      ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: col,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Login →', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
