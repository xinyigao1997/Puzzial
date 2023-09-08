import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:tuple/tuple.dart';
import '../helper.dart';
import '../mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Uint8List sampleImageBytes;

  /// Declare mock instances and gameState object outside the setUp function
  late GameState gameState;
  setUpAll(() async {
    ByteData byteData = await rootBundle.load('assets/images/back.png');
    sampleImageBytes = byteData.buffer.asUint8List();
    // Initialize mock instances and gameState object in the setUp function
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
      const Tuple2(45.0, 45.0),
      const Tuple2(65.0, 65.0),
      const Tuple2(70.0, 70.0),
    ];
  });
  testWidgets(
      'PuzzlePiece should be draggable and update position when not assembled',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      const sessionId = 'test-session';
      var mockDatabaseRef = MockDatabaseReference();
      when(gameState.database!.child(sessionId)).thenReturn(mockDatabaseRef);
      when(gameState.database!.child('$sessionId/pieces/0'))
          .thenReturn(mockDatabaseRef);
      when(mockDatabaseRef.update(any))
          .thenAnswer((_) async => Future.value(null));

      const int pieceId = 0;
      final Image subImage = Image.asset('assets/images/back.png');
      const Offset initialPosition = Offset(30.0, 30.0);
      const Offset previousPosition = Offset(0, 0);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: gameState,
            child: Material(
              child: Stack(
                children: [
                  PuzzlePiece(
                    pieceId: pieceId,
                    subImage: subImage,
                    position: initialPosition,
                    previousPosition: previousPosition,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final puzzlePieceFinder = find.byType(PuzzlePiece);
      expect(puzzlePieceFinder, findsOneWidget);

      const Offset dragOffset = Offset(10, 10);
      final TestGesture gesture = await tester.startGesture(initialPosition);
      await gesture.moveBy(dragOffset);
      await tester.pump();

      // Get the PuzzlePieceState and update the position
      final puzzlePieceState =
          tester.state<PuzzlePieceState>(puzzlePieceFinder);
      puzzlePieceState.widget.position = initialPosition + dragOffset;
      await tester.pump();

      final newPosition = initialPosition + dragOffset;

      expect(puzzlePieceState.widget.previousPosition, const Offset(0, 0));
      expect(40, newPosition.dx);
      expect(40, newPosition.dy);
    });
  });
}
