import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("accessibility test", (WidgetTester tester) async {
        /// Accessibility
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
  });
}