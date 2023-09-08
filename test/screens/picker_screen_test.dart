import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/screens/picker_screen.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:mockito/mockito.dart';
import 'package:puzzial/widgets/image_picker_widget.dart';

class MockGameState extends Mock implements GameState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('PictureSelectorPage renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PictureSelectorPage()));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(LayoutBuilder), findsOneWidget);
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.byType(ImagePickerWidget), findsOneWidget);
  });

    testWidgets('PictureSelectorPage "Home Page" button works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));
    await tester.tap(find.text('START GAME'));
    await tester.pumpAndSettle();
    expect(find.byType(PictureSelectorPage), findsOneWidget);
    // Tap the 'Home page' button
    await tester.tap(find.text('Home Page'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
