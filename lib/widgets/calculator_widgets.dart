import 'package:material_ui/material_ui.dart';

// รูปแบบร่วมกันของแบบกรอก BMI และ BMR
class CalculatorLayout extends StatelessWidget {
  const CalculatorLayout({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final sidePadding = MediaQuery.sizeOf(context).width >= 390 ? 40.0 : 24.0;
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(sidePadding, 42, sidePadding, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorField extends StatelessWidget {
  const CalculatorField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.decimal = true,
    this.isLast = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool decimal;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: label,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: decimal),
            textInputAction: isLast
                ? TextInputAction.done
                : TextInputAction.next,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF5F5961)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  const CalculatorButtons({
    super.key,
    required this.name,
    required this.onCalculate,
    required this.onClear,
  });

  final String name;
  final VoidCallback onCalculate;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final calculateStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF5722),
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(54),
      elevation: 0,
      textStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: onCalculate,
          style: calculateStyle,
          child: Text('คำนวณ $name'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onClear,
          style: calculateStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFADABB1)),
          ),
          child: const Text('ล้างข้อมูล'),
        ),
      ],
    );
  }
}

class CalculatorResult extends StatelessWidget {
  const CalculatorResult({
    super.key,
    required this.name,
    required this.value,
    required this.caption,
    required this.backgroundColor,
    this.borderRadius = BorderRadius.zero,
  });

  final String name;
  final String value;
  final String caption;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFD71610),
                fontSize: 38,
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

final _decimal = RegExp(r'^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$');
final _integer = RegExp(r'^[0-9]+$');

double? parsePositiveDecimal(String text) {
  if (!_decimal.hasMatch(text)) return null;
  final value = double.tryParse(text);
  return value != null && value.isFinite && value > 0 ? value : null;
}

int? parsePositiveAge(String text) {
  if (!_integer.hasMatch(text)) return null;
  final value = int.tryParse(text);
  return value != null && value > 0 ? value : null;
}

void showCalculatorMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
