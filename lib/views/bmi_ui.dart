import 'package:material_ui/material_ui.dart';

import '../widgets/calculator_widgets.dart';

class BmiUI extends StatefulWidget {
  const BmiUI({super.key});

  @override
  State<BmiUI> createState() => _BmiUIState();
}

class _BmiUIState extends State<BmiUI> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _bmi = '0.00';
  String _interpretation = 'การแปรผล';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    FocusScope.of(context).unfocus();
    final weightText = _weightController.text.trim();
    final heightText = _heightController.text.trim();
    if (weightText.isEmpty || heightText.isEmpty) {
      showCalculatorMessage(context, 'กรุณากรอกน้ำหนักและส่วนสูงให้ครบ');
      return;
    }

    final weight = parsePositiveDecimal(weightText);
    final height = parsePositiveDecimal(heightText);
    if (weight == null || height == null) {
      showCalculatorMessage(
        context,
        'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0',
      );
      return;
    }

    // แปลง cm เป็น m ก่อนยกกำลังสองตามสูตร
    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);
    if (!bmi.isFinite || bmi <= 0 || bmi >= 1e21) {
      showCalculatorMessage(context, 'ไม่สามารถคำนวณ BMI จากข้อมูลนี้ได้');
      return;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    setState(() {
      _bmi = bmi.toStringAsFixed(2);
      _interpretation = _interpretBmi(bmi);
    });
  }

  // เทียบ BMI ก่อนปัดเศษกับจุดเริ่มต้นของช่วงถัดไป
  String _interpretBmi(double bmi) {
    // ชดเชยความคลาดเคลื่อนของ double ที่เส้นแบ่งพอดี
    const tolerance = 1e-12;
    if (bmi < 18.5 - tolerance) return 'น้ำหนักต่ำกว่าเกณฑ์';
    if (bmi < 23 - tolerance) return 'น้ำหนักสมส่วน';
    if (bmi < 25 - tolerance) return 'น้ำหนักเกิน';
    if (bmi < 30 - tolerance) return 'โรคอ้วนระดับ 1';
    return 'โรคอ้วนระดับ 2 หรืออ้วนมาก';
  }

  void _clearData() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _bmi = '0.00';
      _interpretation = 'การแปรผล';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      children: [
        const Text(
          'คำนวณหาค่าดัชนีมวลกาย (BMI)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 22),
        Center(
          child: Image.asset('assets/images/bmi.png', width: 138, height: 138),
        ),
        const SizedBox(height: 24),
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
          isLast: true,
        ),
        const SizedBox(height: 24),
        CalculatorButtons(
          name: 'BMI',
          onCalculate: _calculateBmi,
          onClear: _clearData,
        ),
        const SizedBox(height: 22),
        CalculatorResult(
          name: 'BMI',
          value: _bmi,
          caption: _interpretation,
          backgroundColor: const Color(0xFFC8E6C9),
        ),
      ],
    );
  }
}
