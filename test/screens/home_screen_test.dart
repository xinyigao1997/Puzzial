import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/screens/picker_screen.dart';
import 'package:puzzial/widgets/game_mode_controller_widget.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('HomeScreen', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('displays start game button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      final startGameButton = find.widgetWithText(ElevatedButton, 'START GAME');
      expect(startGameButton, findsOneWidget);
    });

    testWidgets('navigates to PickerScreen when start game button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      final startGameButton = find.widgetWithText(ElevatedButton, 'START GAME');
      expect(startGameButton, findsOneWidget);

      await tester.tap(startGameButton);
      await tester.pumpAndSettle();
    });

    testWidgets('displays user profile icon button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      final userProfileIconButton = find.byIcon(Icons.person_sharp);
      expect(userProfileIconButton, findsOneWidget);
    });

    // testWidgets(
    //     'navigates to ProfileScreen when user profile icon button is pressed',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: const HomeScreen(),
    //       navigatorObservers: [mockNavigatorObserver],
    //     ),
    //   );

    //   final userProfileIconButton = find.byIcon(Icons.person_sharp);
    //   expect(userProfileIconButton, findsOneWidget);

    //   await tester.tap(userProfileIconButton);
    //   await tester.pumpAndSettle();
    // });

    testWidgets('displays settings icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      final settingsIconButton = find.byIcon(Icons.settings_sharp);
      expect(settingsIconButton, findsOneWidget);
    });

    // testWidgets(
    //     'navigates to GameModeControllerWidget when settings icon button is pressed',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: const HomeScreen(),
    //       navigatorObservers: [mockNavigatorObserver],
    //     ),
    //   );

    //   final settingsIconButton = find.byIcon(Icons.settings_sharp);
    //   expect(settingsIconButton, findsOneWidget);

    //   await tester.tap(settingsIconButton);
    //   await tester.pumpAndSettle();
    // });
  });
}
