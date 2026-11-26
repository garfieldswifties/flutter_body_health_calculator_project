import 'package:material_ui/material_ui.dart';

import '../widgets/calculator_widgets.dart';

class BmrUI extends StatefulWidget {
  const BmrUI({super.key});

  @override
  State<BmrUI> createState() => _BmrUIState();
}

class _BmrUIState extends State<BmrUI> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isMale = true;
  String _bmr = '0.00';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculateBmr() {
    FocusScope.of(context).unfocus();
    final weightText = _weightController.text.trim();
    final heightText = _heightController.text.trim();
    final ageText = _ageController.text.trim();
    if (weightText.isEmpty || heightText.isEmpty || ageText.isEmpty) {
      showCalculatorMessage(context, 'กรุณากรอกน้ำหนัก ส่วนสูง และอายุให้ครบ');
      return;
    }

    final weight = parsePositiveDecimal(weightText);
    final height = parsePositiveDecimal(heightText);
    final age = parsePositiveAge(ageText);
    if (weight == null || height == null || age == null) {
      showCalculatorMessage(
        context,
        'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
      );
      return;
    }

    // ใช้หน่วย kg, cm และปี ตามสูตรแยกเพศใน Figma
    final bmr = _isMale
        ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    if (!bmr.isFinite || bmr <= 0 || bmr >= 1e21) {
      showCalculatorMessage(context, 'ไม่สามารถคำนวณ BMR จากข้อมูลนี้ได้');
      return;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    setState(() => _bmr = bmr.toStringAsFixed(2));
  }

  void _clearData() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    _weightController.clear();
    _heightController.clear();
    _ageController.clear();
    setState(() {
      _isMale = true;
      _bmr = '0.00';
    });
  }

  Widget _sexButton(String label, bool isMale) {
    final selected = _isMale == isMale;
    return Expanded(
      child: Semantics(
        selected: selected,
        child: ElevatedButton(
          onPressed: () => setState(() => _isMale = isMale),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? const Color(0xFFBBDEFB) : Colors.white,
            foregroundColor: selected
                ? const Color(0xFF153D63)
                : const Color(0xFF262226),
            minimumSize: const Size(0, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontFamily: 'Kanit', fontSize: 16),
            elevation: 2,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      children: [
        const Text(
          'คำนวณหาอัตราการเผาผลาญที่ร่างกายต้องการ (BMR)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 22),
        Center(
          child: Image.asset('assets/images/bmr.png', width: 158, height: 158),
        ),
        const SizedBox(height: 27),
        const Text('เพศ', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            _sexButton('ชาย', true),
            const SizedBox(width: 22),
            _sexButton('หญิง', false),
          ],
        ),
        const SizedBox(height: 22),
        CalculatorField(
          controller: _weightController,
          label: 'น้ำหนัก (kg.)',
          hint: 'กรอกน้ำหนักของคุณ',
        ),
        const SizedBox(height: 16),
        CalculatorField(
          controller: _heightController,
          label: 'ส่วนสูง (cm.)',
          hint: 'กรอกส่วนสูงของคุณ',
        ),
        const SizedBox(height: 16),
        CalculatorField(
          controller: _ageController,
          label: 'อายุ (ปี)',
          hint: 'กรอกอายุของคุณ',
          decimal: false,
          isLast: true,
        ),
        const SizedBox(height: 26),
        CalculatorButtons(
          name: 'BMR',
          onCalculate: _calculateBmr,
          onClear: _clearData,
        ),
        const SizedBox(height: 28),
        CalculatorResult(
          name: 'BMR',
          value: _bmr,
          caption: 'kcal/day',
          backgroundColor: const Color(0xFFC8E6C9),
        ),
      ],
    );
  }
}
