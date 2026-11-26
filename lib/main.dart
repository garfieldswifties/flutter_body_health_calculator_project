import 'package:material_ui/material_ui.dart';

import 'views/splash_screen_ui.dart';

void main() {
  runApp(const FlutterBodyHealthCalculatorProject());
}

class FlutterBodyHealthCalculatorProject extends StatelessWidget {
  const FlutterBodyHealthCalculatorProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body ว้าว',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kanit',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDB3500)),
        scaffoldBackgroundColor: const Color(0xFFFEF7FF),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Color(0xFFDB3500),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const SplashScreenUI(),
    );
  }
}
