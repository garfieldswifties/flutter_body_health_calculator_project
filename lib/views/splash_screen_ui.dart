import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'home_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    // หน่วง 3 วินาทีแล้วเปิด Home แทนเส้นทางเดิม
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (context) => const HomeUI()),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = (MediaQuery.sizeOf(context).height * 0.24).clamp(
      72.0,
      216.0,
    );
    return Scaffold(
      backgroundColor: const Color(0xFFDB3500),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/calculate.png',
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                const Text(
                  'Body Health Calculator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 46),
                const SizedBox.square(
                  dimension: 38,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                    semanticsLabel: 'กำลังเปิดแอป',
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
