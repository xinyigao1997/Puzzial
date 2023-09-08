import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:puzzial/models/player.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/avatar_column_widget.dart';
import 'package:puzzial/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../mock.mocks.dart';
import 'package:flutter/services.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:tuple/tuple.dart';
import '../helper.dart';

class MockGameStateFactory implements GameStateFactory {
  @override
  Future<GameState> create() async {
    // Here, you can create a mocked GameState instance with your custom implementation
    DatabaseReference database = MockDatabaseReference();
    FirebaseStorage storage = MockFirebaseStorage();
    FirebaseApp app = MockFirebaseApp();

    return GameState.internal(database: database, storage: storage, app: app);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Uint8List sampleImageBytes;
  late GameState gameState;

  setUpAll(() async {
    ByteData byteData = await rootBundle.load('assets/images/back.png');
    sampleImageBytes = byteData.buffer.asUint8List();
  });

  group('test avatar column', () {
    setUp(() async {
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

    testWidgets('AvatarColumn displays the correct number of avatars',
        (WidgetTester tester) async {
      // Build the AvatarColumn widget.
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: AvatarColumn())));

        // Find all Avatar widgets.
        final avatarFinder = find.byType(Avatar);

        // Check if the number of Avatar widgets matches the number of players.
        expect(avatarFinder, findsOneWidget);
      });
    });
  });
}
