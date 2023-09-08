import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/models/player.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/grid_widget.dart';
import 'package:puzzial/widgets/puzzle_board_widget.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';

void main() {
  late Uint8List sampleImageBytes;
  late GameState gameState;

  setUpAll(() async {
    ByteData byteData = await rootBundle.load('assets/images/back.png');
    sampleImageBytes = byteData.buffer.asUint8List();
    GameState.factory = MockGameStateFactory();
    // Create a mock GameState object with the mock dependencies
    await GameState.factory.create();
    gameState = GameState.instance;
    gameState.puzzleImage = await uint8ListToXFile(sampleImageBytes);
    gameState.sessionId = 'test-session';
    gameState.screenHeight = 500;
    gameState.screenWidth = 500;
    gameState.components = 3;
    gameState.puzzleLeft = 30;
    gameState.puzzleTop = 30;
    gameState.puzzleHeight = 400;
    gameState.puzzleWidth = 200;
    gameState.puzzleLeftBound = 60;
    gameState.puzzleTopBound = 60;
    gameState.puzzleRightBound = 430;
    gameState.puzzleBottomBound = 430;
    gameState.isGameOver = false;
    gameState.players = [
      Player(
          playerId: 'youngjustice',
          emailAddress: 'abc@gmail.com',
          userName: 'youngjustice',
          profilePhoto: 'https://randomurl.edu')
    ];
    gameState.pieces = [
      PuzzlePiece(
        pieceId: 0,
        position: Offset.zero,
        subImage: Image.memory(Uint8List.fromList([1, 2, 3, 4, 5])),
        previousPosition: Offset.zero,
      ),
      PuzzlePiece(
        pieceId: 1,
        position: Offset.zero,
        subImage: Image.memory(Uint8List.fromList([1, 2, 3, 4, 5])),
        previousPosition: Offset.zero,
      ),
      PuzzlePiece(
        pieceId: 2,
        position: Offset.zero,
        subImage: Image.memory(Uint8List.fromList([1, 2, 3, 4, 5])),
        previousPosition: Offset.zero,
      ),
    ];
    gameState.gridPositions = [
      const Tuple2(50.0, 50.0),
      const Tuple2(60.0, 60.0),
      const Tuple2(60.0, 70.0),
    ];
  });

  testWidgets('PuzzleBoard displays board with given dimensions',
      (WidgetTester tester) async {
    // Define test values for boardTop, boardLeft, boardWidth, boardHeight, and borderSize.
    const boardTop = 100.0;
    const boardLeft = 50.0;
    const boardWidth = 300.0;
    const boardHeight = 300.0;
    const borderSize = 5.0;

    // Build the PuzzleBoard widget.
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<GameState>.value(
          value: gameState,
          child: Stack(
            children: const [
              PuzzleBoard(
                boardTop: boardTop,
                boardLeft: boardLeft,
                boardWidth: boardWidth,
                boardHeight: boardHeight,
                borderSize: borderSize,
              ),
            ],
          ),
        ),
      ),
    );

    // Find the Positioned widget with the given top and left values.
    final positionedFinder = find.byType(Positioned).first;
    final positioned = tester.widget<Positioned>(positionedFinder);
    expect(positioned.top, boardTop);
    expect(positioned.left, boardLeft);

    // Find the Container widget with the BoxDecoration (board background).
    final containerFinder = find
        .descendant(
          of: find.byType(Positioned),
          matching: find.byType(Container),
        )
        .first;
    final container = tester.widget<Container>(containerFinder);

    // Verify the BoxDecoration properties (board background).
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.brown);

    // Verify the dimensions of the board.
    final constraints = container.constraints as BoxConstraints;
    expect(constraints.maxWidth, boardWidth + borderSize * 3);
    expect(constraints.maxHeight, boardHeight + borderSize * 3);

    // Check if the board contains grid cells.
    final gridFinder = find.byType(BorderedGrid);
    expect(gridFinder, findsNWidgets(gameState.gridPositions.length));
  });
}
