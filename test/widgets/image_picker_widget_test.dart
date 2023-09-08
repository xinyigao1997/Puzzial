import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/screens/picker_screen.dart';
import 'package:puzzial/widgets/image_picker_widget.dart';

void main() {
  testWidgets('PictureSelectorPage "camera" button works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));
    await tester.tap(find.text('START GAME'));
    await tester.pumpAndSettle();
    expect(find.byType(PictureSelectorPage), findsOneWidget);

    // Tap the select image button
    expect(find.byType(ImagePickerWidget), findsOneWidget);
    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    final cameraButton = find.text('Camera');
    expect(find.text('Choose puzzle image source'), findsOneWidget);
    expect(cameraButton, findsOneWidget);

    await tester.tap(cameraButton);
    await tester.pumpAndSettle();
    expect(find.byType(PictureSelectorPage), findsOneWidget);
  });

  testWidgets('PictureSelectorPage "gallery" button works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));
    await tester.tap(find.text('START GAME'));
    await tester.pumpAndSettle();
    expect(find.byType(PictureSelectorPage), findsOneWidget);

    // Tap the select image button
    expect(find.byType(ImagePickerWidget), findsOneWidget);
    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    final galleryButton = find.text('Gallery');
    expect(find.text('Choose puzzle image source'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);

    await tester.tap(galleryButton);
    await tester.pumpAndSettle();
    expect(find.byType(PictureSelectorPage), findsOneWidget);
  });
}
