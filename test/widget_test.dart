import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_body_health_calculator_project/main.dart';
import 'package:flutter_body_health_calculator_project/views/about_ui.dart';
import 'package:flutter_body_health_calculator_project/views/bmi_ui.dart';
import 'package:flutter_body_health_calculator_project/views/bmr_ui.dart';
import 'package:flutter_body_health_calculator_project/views/home_ui.dart';
import 'package:flutter_body_health_calculator_project/views/splash_screen_ui.dart';
import 'package:flutter_body_health_calculator_project/widgets/calculator_widgets.dart';

Future<void> openApp(
  WidgetTester tester, {
  Size size = const Size(430, 932),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(const FlutterBodyHealthCalculatorProject());
}

Future<void> openCalculator(WidgetTester tester, int index) async {
  await openApp(tester);
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
  await tapTab(tester, index);
}

Future<void> tapTab(WidgetTester tester, int index) async {
  final tabs = find.byType(BottomNavigationBar);
  final label = ['BMI', 'About', 'BMR'][index];
  await tester.tap(find.descendant(of: tabs, matching: find.text(label)));
  await tester.pumpAndSettle();
}

Future<void> enterFields(WidgetTester tester, List<String> values) async {
  for (var i = 0; i < values.length; i++) {
    final field = find.byType(TextField).at(i);
    await tester.ensureVisible(field);
    await tester.enterText(field, values[i]);
    await tester.pump();
  }
}

Future<void> tapButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(ElevatedButton, label);
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Splash replaces its route after three seconds, then About opens',
    (tester) async {
      await openApp(tester);
      expect(find.byType(SplashScreenUI), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 2999));
      expect(find.byType(HomeUI), findsNothing);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(HomeUI), findsOneWidget);
      expect(find.byType(AboutUI), findsOneWidget);
      expect(find.text('© 2026 SAU. All rights reserved.'), findsOneWidget);
      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        1,
      );
      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .items
            .map((item) => item.label),
        ['BMI', 'About', 'BMR'],
      );

      await tapTab(tester, 0);
      expect(find.byType(BmiUI), findsOneWidget);
      await tapTab(tester, 2);
      expect(find.byType(BmrUI), findsOneWidget);

      final context = tester.element(find.byType(HomeUI));
      expect(Navigator.of(context).canPop(), isFalse);
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(handled, isFalse);
      expect(find.byType(SplashScreenUI), findsNothing);

      await tapTab(tester, 1);
      expect(find.byType(AboutUI), findsOneWidget);
    },
  );

  testWidgets('About shows the reviewed text and colors', (tester) async {
    await openCalculator(tester, 1);
    const textColors = {
      'Body Health Calculator': Color(0xFFE64A19),
      'คำนวณหาค่าดัชนีมวลกาย (BMI)': Color(0xFFE64A19),
      'คำนวณหาแคลอรี่ที่ร่างกายต้องการ (BMR)': Color(0xFFE64A19),
      '© 2026 SAU. All rights reserved.': Color(0xFF616161),
      'Created by SAU Software Development Team': Color(0xFF616161),
    };
    for (final entry in textColors.entries) {
      final text = find.descendant(
        of: find.byType(AboutUI),
        matching: find.text(entry.key),
      );
      await tester.ensureVisible(text);
      await tester.pumpAndSettle();
      expect(text.hitTestable(), findsOneWidget);
      expect(tester.widget<Text>(text).style?.color, entry.value);
    }
  });

  testWidgets('BMR result uses the same green square card as BMI', (
    tester,
  ) async {
    await openCalculator(tester, 0);
    final card = find.descendant(
      of: find.byType(CalculatorResult),
      matching: find.byType(Container),
    );
    final bmiStyle = tester.widget<Container>(card).decoration;
    await tapTab(tester, 2);
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();

    final bmrStyle = tester.widget<Container>(card).decoration as BoxDecoration;
    expect(bmrStyle.color, const Color(0xFFC8E6C9));
    expect(bmrStyle.borderRadius, BorderRadius.zero);
    expect(bmrStyle, bmiStyle);
  });

  const bmiCases = [
    ('18.49', '100', '18.49', 'น้ำหนักต่ำกว่าเกณฑ์'),
    ('18.50', '100', '18.50', 'น้ำหนักสมส่วน'),
    ('18.51', '100', '18.51', 'น้ำหนักสมส่วน'),
    ('22.90', '100', '22.90', 'น้ำหนักสมส่วน'),
    ('22.95', '100', '22.95', 'น้ำหนักสมส่วน'),
    ('22.999', '100', '23.00', 'น้ำหนักสมส่วน'),
    ('23', '100', '23.00', 'น้ำหนักเกิน'),
    ('58.88', '160', '23.00', 'น้ำหนักเกิน'),
    ('23.01', '100', '23.01', 'น้ำหนักเกิน'),
    ('24.90', '100', '24.90', 'น้ำหนักเกิน'),
    ('24.95', '100', '24.95', 'น้ำหนักเกิน'),
    ('25', '100', '25.00', 'โรคอ้วนระดับ 1'),
    ('25.01', '100', '25.01', 'โรคอ้วนระดับ 1'),
    ('29.90', '100', '29.90', 'โรคอ้วนระดับ 1'),
    ('29.95', '100', '29.95', 'โรคอ้วนระดับ 1'),
    ('30', '100', '30.00', 'โรคอ้วนระดับ 2 หรืออ้วนมาก'),
    ('30.01', '100', '30.01', 'โรคอ้วนระดับ 2 หรืออ้วนมาก'),
    ('59.5', '162.4', '22.56', 'น้ำหนักสมส่วน'),
  ];

  for (final (weight, height, result, category) in bmiCases) {
    testWidgets('BMI $weight kg / $height cm -> $result / $category', (
      tester,
    ) async {
      await openCalculator(tester, 0);
      await enterFields(tester, [weight, height]);
      await tapButton(tester, 'คำนวณ BMI');
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == result,
        ),
        findsOneWidget,
      );
      expect(find.text(category), findsOneWidget);
    });
  }

  const bmrCases = [
    ('ชาย', '70', '175', '30', '1695.67'),
    ('หญิง', '70', '175', '30', '1507.13'),
    ('ชาย', '72.5', '178.5', '32', '1734.60'),
    ('หญิง', '59.5', '162.4', '28', '1379.66'),
  ];

  for (final (sex, weight, height, age, result) in bmrCases) {
    testWidgets('BMR $sex / $weight kg / $height cm / $age yr -> $result', (
      tester,
    ) async {
      await openCalculator(tester, 2);
      await tapButton(tester, sex);
      await enterFields(tester, [weight, height, age]);
      await tapButton(tester, 'คำนวณ BMR');
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == result,
        ),
        findsOneWidget,
      );
      expect(find.text('kcal/day'), findsOneWidget);
    });
  }

  final invalidBmi = [
    ('blank', ' ', '175', 'กรุณากรอกน้ำหนักและส่วนสูงให้ครบ'),
    ('malformed', '7.2.5', '175', 'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0'),
    ('zero', '70', '0', 'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0'),
    ('negative', '-70', '175', 'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0'),
    ('NaN', 'NaN', '175', 'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0'),
    ('Infinity', '70', 'Infinity', 'น้ำหนักและส่วนสูงต้องเป็นตัวเลขมากกว่า 0'),
    (
      'unrepresentable',
      '70',
      '0.${'0' * 200}1',
      'ไม่สามารถคำนวณ BMI จากข้อมูลนี้ได้',
    ),
  ];

  for (final (caseName, weight, height, message) in invalidBmi) {
    testWidgets('BMI validation: $caseName', (tester) async {
      await openCalculator(tester, 0);
      await enterFields(tester, [weight, height]);
      await tapButton(tester, 'คำนวณ BMI');
      expect(find.text(message), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });
  }

  final invalidBmr = [
    ('blank', '70', '175', '', 'กรุณากรอกน้ำหนัก ส่วนสูง และอายุให้ครบ'),
    (
      'malformed age',
      '70',
      '175',
      'สามสิบ',
      'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
    ),
    (
      'negative weight',
      '-70',
      '175',
      '30',
      'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
    ),
    (
      'zero height',
      '70',
      '0',
      '30',
      'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
    ),
    (
      'zero age',
      '70',
      '175',
      '0',
      'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
    ),
    (
      'decimal age',
      '70',
      '175',
      '30.5',
      'น้ำหนักและส่วนสูงต้องมากกว่า 0 และอายุต้องเป็นจำนวนเต็มมากกว่า 0',
    ),
    (
      'nonpositive result',
      '1',
      '1',
      '99',
      'ไม่สามารถคำนวณ BMR จากข้อมูลนี้ได้',
    ),
    (
      'overflow result',
      '9' * 308,
      '175',
      '30',
      'ไม่สามารถคำนวณ BMR จากข้อมูลนี้ได้',
    ),
  ];

  for (final (caseName, weight, height, age, message) in invalidBmr) {
    testWidgets('BMR validation: $caseName', (tester) async {
      await openCalculator(tester, 2);
      await enterFields(tester, [weight, height, age]);
      await tapButton(tester, 'คำนวณ BMR');
      expect(find.text(message), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });
  }

  testWidgets('BMI reset and navigation restore the initial form', (
    tester,
  ) async {
    await openCalculator(tester, 0);
    await enterFields(tester, ['70', '175']);
    await tapButton(tester, 'คำนวณ BMI');
    expect(find.text('22.86'), findsOneWidget);
    await tapButton(tester, 'ล้างข้อมูล');
    expect(find.text('0.00'), findsOneWidget);
    expect(find.text('การแปรผล'), findsOneWidget);
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.controller!.text.isEmpty),
      isTrue,
    );

    await enterFields(tester, ['60', '160']);
    await tapTab(tester, 1);
    await tapTab(tester, 0);
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.controller!.text.isEmpty),
      isTrue,
    );
  });

  testWidgets('BMR reset restores the male selection, inputs and result', (
    tester,
  ) async {
    await openCalculator(tester, 2);
    await tapButton(tester, 'หญิง');
    await enterFields(tester, ['70', '175', '30']);
    await tapButton(tester, 'คำนวณ BMR');
    expect(find.text('1507.13'), findsOneWidget);
    await tapButton(tester, 'ล้างข้อมูล');
    expect(find.text('0.00'), findsOneWidget);
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.controller!.text.isEmpty),
      isTrue,
    );
    final male = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'ชาย'),
    );
    expect(male.style!.backgroundColor!.resolve({}), const Color(0xFFBBDEFB));
  });

  for (final size in [const Size(430, 932), const Size(320, 568)]) {
    testWidgets(
      'Safe area and keyboard insets at ${size.width} × ${size.height}',
      (tester) async {
        await openApp(tester, size: size);
        tester.view.padding = const FakeViewPadding(top: 44, bottom: 25);
        addTearDown(tester.view.resetPadding);

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
        final credit = find.text('Created by SAU Software Development Team');
        await tester.ensureVisible(credit);
        await tester.pumpAndSettle();
        expect(credit.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tapTab(tester, 2);
        final age = find.byType(TextField).last;
        await tester.ensureVisible(age);
        await tester.showKeyboard(age);
        tester.view.viewInsets = const FakeViewPadding(bottom: 240);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();
        await tester.ensureVisible(age);
        await tester.pumpAndSettle();
        expect(tester.testTextInput.isVisible, isTrue);
        expect(
          tester.getBottomLeft(age).dy,
          lessThanOrEqualTo(size.height - 240),
        );
        expect(tester.takeException(), isNull);

        tester.view.resetViewInsets();
        await enterFields(tester, ['70', '175', '30']);
        await tapButton(tester, 'คำนวณ BMR');
        final result = find.text('1695.67');
        await tester.ensureVisible(result);
        await tester.pumpAndSettle();
        expect(result.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
