import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'about_ui.dart';
import 'bmi_ui.dart';
import 'bmr_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // เปิดที่แท็บ About ตามตัวอย่างใน Lecture 07
  int _currentIndex = 1;
  final List<Widget> _pages = const [BmiUI(), AboutUI(), BmrUI()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Health Calculator')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFEF7FF),
        selectedItemColor: const Color(0xFFDB3500),
        unselectedItemColor: const Color(0xFF666268),
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'BMI'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'About'),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.personBooth),
            label: 'BMR',
          ),
        ],
      ),
    );
  }
}
