import 'package:material_ui/material_ui.dart';

class AboutUI extends StatelessWidget {
  const AboutUI({super.key});

  @override
  Widget build(BuildContext context) {
    const contentColor = Color(0xFFE64A19);
    const descriptionStyle = TextStyle(
      color: contentColor,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.2,
    );
    const footerStyle = TextStyle(
      color: Color(0xFF616161),
      fontSize: 13,
      height: 1.35,
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topSpace = (constraints.maxHeight * 0.34).clamp(24.0, 284.0);
          final creditSpace = (constraints.maxHeight * 0.17).clamp(24.0, 144.0);
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, topSpace, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: [
                    const Text(
                      'Body Health Calculator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 23),
                    Image.asset(
                      'assets/images/calculate.png',
                      width: 112,
                      height: 112,
                    ),
                    const SizedBox(height: 34),
                    const Text(
                      'คำนวณหาค่าดัชนีมวลกาย (BMI)',
                      textAlign: TextAlign.center,
                      style: descriptionStyle,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'คำนวณหาแคลอรี่ที่ร่างกายต้องการ (BMR)',
                      textAlign: TextAlign.center,
                      style: descriptionStyle,
                    ),
                    SizedBox(height: creditSpace),
                    Image.asset(
                      'assets/images/saulogo.png',
                      width: 58,
                      height: 58,
                      semanticLabel: 'มหาวิทยาลัยเอเชียอาคเนย์',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '© 2026 SAU. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: footerStyle,
                    ),
                    const Text(
                      'Created by SAU Software Development Team',
                      textAlign: TextAlign.center,
                      style: footerStyle,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
