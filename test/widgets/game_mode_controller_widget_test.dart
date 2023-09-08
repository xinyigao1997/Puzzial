import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/screens/home_screen.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/game_mode_controller_widget.dart';

void main() {
  testWidgets('CustomChip should show label and change selection state on tap',
      (WidgetTester tester) async {
    bool isSelected = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomChip(
          label: 'Test Label',
          selected: isSelected,
          onSelect: (selected) {
            isSelected = selected;
          },
        ),
      ),
    ));

    // Verify that the label is displayed
    expect(find.text('Test Label'), findsOneWidget);

    // Verify that the initial state is not selected
    expect(isSelected, isFalse);

    // Tap on the widget
    await tester.tap(find.byType(CustomChip));
    await tester.pumpAndSettle();

    // Verify that the widget is now selected
    expect(isSelected, isTrue);

    // Tap on the widget again
    await tester.tap(find.byType(CustomChip));
    await tester.pumpAndSettle();

    // Verify that the widget is now unselected
    expect(isSelected, isTrue);
  });

  testWidgets('Content widget displays title and child widget', (tester) async {
    const title = 'My Title';
    const child = Text('Hello, world!');

    await tester.pumpWidget(
        const MaterialApp(home: Content(title: title, child: child)));

    expect(find.text(title), findsOneWidget);
    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets(
      'GameModeControllerWidget displays correct options and updates game state',
      (WidgetTester tester) async {
    // Build the widget
    await tester
        .pumpWidget(const MaterialApp(home: GameModeControllerWidget()));

    // Find the Difficulty Level chips
    final difficultyLevelChips = find.byType(CustomChip).at(0);

    // Find different level widgets
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Hell'), findsOneWidget);

    // Check if the initial selected difficulty level is Easy
    expect(GameState.instance.currentLevel, equals(0));

    // Tap on the Medium difficulty level chip
    final mediumLevelChoiceItem = find.text('Medium');
    await tester.tap(mediumLevelChoiceItem);
    await tester.pumpAndSettle();

    // Check if the selected difficulty level is now Medium
    expect(GameState.instance.currentLevel, equals(1));

    // Tap on the Hard difficulty level chip
    final hardLevelChoiceItem = find.text('Hard');
    await tester.tap(hardLevelChoiceItem);
    await tester.pumpAndSettle();

    // Check if the selected difficulty level is now Hard
    expect(GameState.instance.currentLevel, equals(2));

    // Tap on the Hell difficulty level chip
    final hellLevelChoiceItem = find.text('Hell');
    await tester.tap(hellLevelChoiceItem);
    await tester.pumpAndSettle();

    // Check if the selected difficulty level is now Hell
    expect(GameState.instance.currentLevel, equals(3));

    // Check if the initial selected game mode is One Player
    expect(GameState.instance.isSinglePlayer, equals(true));

    // Check options exist
    expect(find.text('One Player'), findsOneWidget);
    expect(find.text('Two Players'), findsOneWidget);

    // Tap on the Two Players game mode chip
    await tester.tap(find.text('Two Players'));
    await tester.pumpAndSettle();

    // Check game mode is now Two Players
    expect(GameState.instance.isSinglePlayer, equals(false));
  });

  testWidgets('Home Page navigation works correctly',
      (WidgetTester tester) async {
    // build widget tree by starting from home page then navigate to game mode controller page
    // build the widget
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final buttonToGameModeNavigator = find.byType(IconButton).at(1);
    expect(buttonToGameModeNavigator, findsOneWidget);

    // navigate to game mode controller page
    await tester.tap(buttonToGameModeNavigator);
    await tester.pumpAndSettle();
    final gameModeControllerPage = find.byType(GameModeControllerWidget);
    expect(gameModeControllerPage, findsOneWidget);

    // find home page button
    final containerForHomeButton = find.byType(Container).at(3);
    expect(containerForHomeButton, findsOneWidget);
    final homePageButton = find.text('Home Page');
    expect(homePageButton, findsOneWidget);

    // test tab
    await tester.tap(homePageButton);
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
