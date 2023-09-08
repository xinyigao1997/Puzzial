import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/pieces_left_indicator_widget.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';
import '../mock.mocks.dart';

class FakeDatabaseEvent implements DatabaseEvent {
  @override
  final DataSnapshot snapshot;
  final DatabaseReference previousSiblingKey;

  FakeDatabaseEvent({required this.snapshot, required this.previousSiblingKey});

  @override
  String? get previousChildKey => 'test-previous-child-key';

  @override
  DatabaseEventType get type => DatabaseEventType.value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Uint8List sampleImageBytes;
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
      const Tuple2(50.0, 50.0),
      const Tuple2(60.0, 60.0),
      const Tuple2(60.0, 70.0),
    ];
  });
  group('PiecesLeftIndicator', () {
    testWidgets('should update pieces left count', (WidgetTester tester) async {
      var mockDatabaseRef = MockDatabaseReference();

      // Stub the 'child' method of the mock object
      when(gameState.database!.child('test-session'))
          .thenReturn(mockDatabaseRef);
      when(gameState.database!.child('test-session/components'))
          .thenReturn(mockDatabaseRef);
      when(mockDatabaseRef.onValue).thenAnswer((_) {
        return Stream<DatabaseEvent>.fromIterable([]);
      });

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: PiecesLeftIndicator(),
        ),
      ));

      expect(find.text('Left: 3'), findsOneWidget);
    });
  });
}
