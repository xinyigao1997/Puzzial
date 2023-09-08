import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/screens/post_game_screen.dart';

void main() {
  group('test post game screen', () {
    testWidgets('test congrats successfully rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: GameEndPage(
        onMainMenuPressed: () {},
      )));
      expect(find.text('Congrats!'), findsOneWidget);
      expect(find.text('Home Page'), findsOneWidget);
    });
    testWidgets('test Return To Main Menu works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: GameEndPage(
        onMainMenuPressed: () {},
      )));
      expect(find.text('Home Page'), findsOneWidget);
      await tester.tap(find.text('Home Page'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
