import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/widgets/button_widget.dart';

void main() {
  testWidgets(
      'CustomButton displays an image and calls the callback when tapped',
      (WidgetTester tester) async {
    var tapped = false;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onTap: () {
              tapped = true;
            },
            imageUrl: 'assets/images/back.png',
          ),
        ),
      ),
    );

    // Expect to find the image
    expect(find.byType(Image), findsOneWidget);

    // Tap the button
    await tester.tap(find.byType(CustomButton));

    // Expect that the onTap callback is executed
    expect(tapped, true);
  });
}
