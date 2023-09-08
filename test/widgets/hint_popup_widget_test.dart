import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/widgets/hint_popup_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HintPopUp', () {
    testWidgets('HintPopUp is correctly displayed and toggles visibility',
        (WidgetTester tester) async {
      // Create a sample HintPopUp instance
      final visible = ValueNotifier<bool>(true);
      final ByteData byteData = await rootBundle.load('assets/images/back.png');
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final hintPopUp = HintPopUp(
        imageBytes: imageBytes,
        visible: visible,
      );

      // Build the MaterialApp and HintPopUp widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: hintPopUp,
          ),
        ),
      );

      // Find the HintPopUp widget
      final hintPopUpFinder = find.byType(HintPopUp);

      // Check if the HintPopUp widget is present
      expect(hintPopUpFinder, findsOneWidget);

      // Check if the HintPopUp is initially visible
      expect(visible.value, true);

      // Tap the HintPopUp to toggle its visibility
      await tester.tap(hintPopUpFinder);
      await tester.pumpAndSettle();

      // Check if the HintPopUp is hidden after tapping
      expect(visible.value, false);

      // Tap the HintPopUp to toggle its visibility again
      await tester.tap(hintPopUpFinder);
      await tester.pumpAndSettle();

      // Check if the HintPopUp is visible again after tapping
      expect(visible.value, false);
    });
  });
}
