import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/widgets/grid_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BorderedGrid', () {
    testWidgets('BorderedGrid is correctly displayed',
        (WidgetTester tester) async {
      // Create a sample BorderedGrid instance
      const borderedGrid = BorderedGrid(
        gridLeft: 10.0,
        gridTop: 20.0,
        gridHeight: 100,
        gridWidth: 200,
        borderOpacity: 0.5,
      );

      // Build the MaterialApp and BorderedGrid widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: const [borderedGrid],
            ),
          ),
        ),
      );

      // Find the BorderedGrid widget
      final gridFinder = find.byType(BorderedGrid);

      // Check if the BorderedGrid widget is present
      expect(gridFinder, findsOneWidget);

      // Check if the Positioned widget has the correct properties
      final positionedWidget = tester.widget<Positioned>(find.descendant(
        of: gridFinder,
        matching: find.byType(Positioned),
      ));

      expect(positionedWidget.left, borderedGrid.gridLeft);
      expect(positionedWidget.top, borderedGrid.gridTop);
    });
  });
}
