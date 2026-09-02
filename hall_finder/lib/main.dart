import 'dart:async';
import 'package:flutter/material.dart';
import 'data/constants.dart';
import 'data/helpers.dart';
import 'screens/dean_screen.dart';
import 'screens/faculty_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student_screen.dart';
import 'theme.dart';

void main() {
  runApp(const HallFinderApp());
}

class HallFinderApp extends StatelessWidget {
  const HallFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hall Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue, brightness: Brightness.dark),
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // ── State — mirrors the useState hooks in the original React app ──────────
  String screen = 'landing';
  String? role; // 'dean' | 'faculty'
  DateTime now = DateTime.now();
  late String selDay = detectDay();
  dynamic curSid = getCurSlotId();
  late dynamic selPid = getCurSlotId() ?? 1;
  bool pidLive = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final sid = getCurSlotId();
      setState(() {
        now = DateTime.now();
        curSid = sid;
        if (pidLive && sid != null) selPid = sid;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  dynamic get effPid => pidLive ? curSid : selPid;

  void _logout() {
    setState(() {
      screen = 'landing';
    });
  }

  void _goLogin(String r) {
    setState(() {
      role = r;
      screen = 'login';
    });
  }

  bool _tryLogin(String passkey) {
    final expected = role == 'dean' ? deanKey : facultyKey;
    if (expected == passkey) {
      setState(() => screen = role!);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    switch (screen) {
      case 'landing':
        return LandingScreen(
          onSelectRole: (r) {
            if (r == 'student') {
              setState(() => screen = 'student');
            } else {
              _goLogin(r);
            }
          },
        );

      case 'login':
        return LoginScreen(
          role: role!,
          tryLogin: _tryLogin,
          onBack: () => setState(() => screen = 'landing'),
        );

      case 'dean':
        return DeanScreen(
          selDay: selDay,
          onSelDay: (d) => setState(() => selDay = d),
          now: now,
          curSid: curSid,
          onLogout: _logout,
        );

      case 'faculty':
        return FacultyScreen(
          selDay: selDay,
          onSelDay: (d) => setState(() => selDay = d),
          now: now,
          curSid: curSid,
          selPid: selPid,
          onSelPid: (p) => setState(() => selPid = p),
          pidLive: pidLive,
          onPidLive: (v) => setState(() => pidLive = v),
          effPid: effPid,
          onLogout: _logout,
        );

      case 'student':
        return StudentScreen(
          selDay: selDay,
          now: now,
          curSid: curSid,
          selPid: selPid,
          onSelPid: (p) => setState(() => selPid = p),
          pidLive: pidLive,
          onPidLive: (v) => setState(() => pidLive = v),
          effPid: effPid,
          onHome: () => setState(() => screen = 'landing'),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
