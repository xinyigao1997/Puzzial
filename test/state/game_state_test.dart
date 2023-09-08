import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:tuple/tuple.dart';

import '../helper.dart';
import '../mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Uint8List sampleImageBytes;
  setUpAll(() async {
    ByteData byteData = await rootBundle.load('assets/images/back.png');
    sampleImageBytes = byteData.buffer.asUint8List();
  });

  group('GameState', () {
    /// Declare mock instances and gameState object outside the setUp function
    late GameState gameState;

    setUp(() async {
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

    test('test set gameover', () {
      gameState.setGameOver(true);
      expect(gameState.isGameOver, true);
    });

    test('randomInRange generates a random double within the specified range',
        () {
      const double min = 5.0;
      const double max = 10.0;
      const int iterations = 1000;

      for (var i = 0; i < iterations; i++) {
        final randomValue = gameState.randomInRange(min, max);

        expect(randomValue, greaterThanOrEqualTo(min));
        expect(randomValue, lessThan(max));
      }
    });

    test('Reset puzzle', () async {
      var childRef = MockDatabaseReference();

      when(gameState.database?.child('test-session/')).thenReturn(childRef);

      when(childRef.update(argThat(isNotNull)))
          .thenAnswer((_) => Future.value(null));
      await gameState.resetPuzzle();

      /// Verify that the puzzle bounds have been set
      // Check if the puzzle bounds have been updated
      expect(gameState.puzzleLeftBound, 50.0);
      expect(gameState.puzzleTopBound, 50.0);
      expect(gameState.puzzleRightBound, 300.0);
      expect(gameState.puzzleBottomBound, 300.0);

      /// Verify that the puzzle pieces have been randomized
      expect(gameState.pieces[0].position, isNot(const Offset(0, 0)));
      expect(gameState.pieces[1].position, isNot(const Offset(0, 0)));
      expect(gameState.pieces[2].position, isNot(const Offset(0, 0)));
    });

    test('Test toJson function', () async {
      // Call toJson
      Map<String, dynamic> json = await gameState.toJson();

      // Verify that the returned JSON map contains the expected data
      expect(json['rows'], gameState.rows);
      expect(json['cols'], gameState.cols);
      expect(json['components'], gameState.components);
      expect(json['isGameOver'], gameState.isGameOver);
      expect(json['numOfPlayer'], gameState.players.length);

      // Verify pieces data
      List<Map<String, dynamic>> pieces = json['pieces'];
      for (int i = 0; i < gameState.pieces.length; i++) {
        expect(pieces[i]['isAssembled'], gameState.pieces[i].isAssembled);
        expect(pieces[i]['isOccupied'], gameState.pieces[i].isOccupied);
        expect(pieces[i]['position']['left'], gameState.pieces[i].position.dx);
        expect(pieces[i]['position']['top'], gameState.pieces[i].position.dy);
      }

      // Verify grid positions data
      List<Map<String, dynamic>> gridPos = json['gridPos'];
      for (int i = 0; i < gameState.gridPositions.length; i++) {
        expect(gridPos[i]['x'], gameState.gridPositions[i].item1);
        expect(gridPos[i]['y'], gameState.gridPositions[i].item2);
      }
    });

    test('Test saveState function', () async {
      var childRef = MockDatabaseReference();
      const session = 'test-session';
      when(childRef.update(argThat(isNotNull)))
          .thenAnswer((_) => Future.value(null));
      // Call saveState
      await gameState.saveState(session);

      // Call toJson to get the expected data for verification
      Map<String, dynamic> expectedState = await gameState.toJson();

      // Verify that the database update method is called with the expected data
      verify(gameState.database?.update({session: expectedState})).called(1);
    });

    test('xFileToUiImage should return a ui.Image from an XFile', () async {
      XFile file = XFile.fromData(sampleImageBytes);
      ui.Image result = await gameState.xFileToUiImage(file);

      expect(result, isNotNull);
      expect(result, isInstanceOf<ui.Image>());
    });

    test('uintBytesToImage should return a ui.Image from a Uint8List',
        () async {
      ui.Image result = await gameState.uintBytesToImage(sampleImageBytes);

      expect(result, isNotNull);
      expect(result, isInstanceOf<ui.Image>());
    });

    test('bytesToUiImage should return a ui.Image from a Uint8List', () async {
      ui.Image result = await gameState.bytesToUiImage(sampleImageBytes);

      expect(result, isNotNull);
      expect(result, isInstanceOf<ui.Image>());
    });

    test('Generate puzzle from imageBytes', () async {
      List<PuzzlePiece> pieces =
          await gameState.generatePuzzle(imageBytes: sampleImageBytes);

      expect(pieces, isNotNull);
      expect(pieces, isA<List<PuzzlePiece>>());
      expect(pieces.length, equals(4));
    });

    test('Generate puzzle from piecesInfo', () async {
      List<Map<String, dynamic>> piecesInfo = [
        {
          'position': {'left': 0.0, 'top': 0.0},
          'isAssembled': false,
          'isOccupied': false
        },
        {
          'position': {'left': 0.0, 'top': 0.0},
          'isAssembled': false,
          'isOccupied': false
        },
        {
          'position': {'left': 0.0, 'top': 0.0},
          'isAssembled': false,
          'isOccupied': false
        },
        {
          'position': {'left': 0.0, 'top': 0.0},
          'isAssembled': false,
          'isOccupied': false
        },
      ];

      List<PuzzlePiece> pieces =
          await gameState.generatePuzzle(piecesInfo: piecesInfo);

      // Assert
      expect(pieces, isNotNull);
      expect(pieces, isA<List<PuzzlePiece>>());
      expect(pieces.length, equals(4));
    });

    // test('should save image to Firebase storage and update download URL',
    //     () async {
    //   MockFile mockFile = MockFile();
    //   MockReference mockReference = MockReference();
    //   MockTaskSnapshot mockTaskSnapshot = MockTaskSnapshot();
    //   MockFirebaseStorage mockFirebaseStorage = MockFirebaseStorage();

    //   const sessionId = 'test-session';
    //   const filePath = 'images/$sessionId.png';
    //   const imageUrl = 'https://example.com/image.png';

    //   when(mockFile.path).thenReturn('test_image.png');
    //   when(mockFirebaseStorage.ref()).thenReturn(mockReference);
    //   when(mockReference.child(any)).thenReturn(mockReference);
    //   // when(mockReference.putFile(any))
    //   //     .thenAnswer((_) async => mockTaskSnapshot);
    //   when(mockTaskSnapshot.ref).thenReturn(mockReference);
    //   when(mockReference.getDownloadURL())
    //       .thenAnswer((_) async => 'https://test-download-url.com');

    //   await gameState.saveImageToStorage();

    //   // Verify the interactions
    //   verify(mockFile.path);
    //   verify(mockFirebaseStorage.ref()).called(1);
    //   verify(mockReference.child('images/test-session.png')).called(1);
    //   verify(mockReference.putFile(mockFile)).called(1);
    //   verify(mockTaskSnapshot.ref).called(1);
    //   verify(mockReference.getDownloadURL()).called(1);
    // });

    test('Should return false if sessionId is empty', () async {
      bool result = await gameState.validateSession('');
      expect(result, false);
    });

    test('Should return false if the session does not exist', () async {
      const sessionId = 'non_existing_session_id';
      var mockDataSnapshot = MockDataSnapshot();
      var mockDatabaseRef = MockDatabaseReference();
      when(gameState.database!.child(sessionId)).thenReturn(mockDatabaseRef);
      when(mockDatabaseRef.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn({});

      bool result = await gameState.validateSession(sessionId);
      expect(result, false);
    });

    test('should update game state with session data if session exists',
        () async {
      var mockDataSnapshot = MockDataSnapshot();
      var mockStorageRef = MockReference();
      var mockDatabaseRef = MockDatabaseReference();
      // Stub the necessary data
      Map<String, dynamic> sessionData = {
        'rows': 3,
        'cols': 3,
        'components': 9,
        'isGameOver': false,
        'gridPos': [
          {'x': 0, 'y': 0},
          {'x': 1, 'y': 1},
          {'x': 2, 'y': 2},
          {'x': 0, 'y': 0},
          {'x': 1, 'y': 1},
          {'x': 2, 'y': 2},
          {'x': 0, 'y': 0},
          {'x': 1, 'y': 1},
          {'x': 2, 'y': 2},
        ],
        'pieces': [
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
          {
            'isAssembled': false,
            'isOccupied': false,
            'position': {'left': 20.0, 'top': 20.0}
          },
        ],
      };
      const sessionId = 'test-session';
      const imageLink = 'https://example.com/image.png';
      // when(sessionId.isEmpty).thenReturn(true);
      when(gameState.database!.child(sessionId)).thenReturn(mockDatabaseRef);
      when(mockDatabaseRef.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.exists).thenReturn(true);
      when(mockDataSnapshot.value).thenReturn(sessionData);

      when(gameState.storage!.refFromURL(imageLink)).thenReturn(mockStorageRef);
      when(mockStorageRef.getData())
          .thenAnswer((_) async => Future.value(sampleImageBytes));

      // Call the reloadSession method
      await gameState.reloadSession(sessionId, imageLink);

      // Verify the game state properties are updated
      expect(gameState.rows, 3);
      expect(gameState.cols, 3);
      expect(gameState.components, 9);
      expect(gameState.isGameOver, false);
      expect(gameState.gridPositions.length, 18);
      expect(gameState.pieces.length, 9);
      expect(gameState.gridPositions[0], const Tuple2(0, 0));
      expect(gameState.gridPositions[1], const Tuple2(1, 1));
      expect(gameState.gridPositions[2], const Tuple2(2, 2));
    });

    test('should return early if the session does not exist', () async {
      const sessionId = 'test-session';
      const imageLink = 'https://asdasda.edu';
      var mockDataSnapshot = MockDataSnapshot();
      var mockDatabaseRef = MockDatabaseReference();
      when(gameState.database!.child(sessionId)).thenReturn(mockDatabaseRef);
      when(mockDatabaseRef.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.exists).thenReturn(false);
      await gameState.reloadSession(sessionId, imageLink);
      expect(gameState.downloadUrl, isNot(imageLink));
      expect(gameState.pieces.length, isNot(9));
    });

    test('updates piece position, isAssembled, and isOccupied', () async {
      await gameState.notifyGameChange(
        pieceId: 1,
        left: 100,
        top: 100,
        isAssembled: true,
        isOccupied: true,
      );

      // Assert
      final updatedPiece = gameState.pieces[1];
      expect(updatedPiece.position, const Offset(100, 100));
      expect(updatedPiece.isAssembled, true);
      expect(updatedPiece.isOccupied, true);
    });

    test('updates isGameOver and components', () async {
      await gameState.notifyGameChange(
        isGameOver: true,
        components: 3,
      );

      // Assert
      expect(gameState.isGameOver, true);
      expect(gameState.components, 3);
    });
  });
}
