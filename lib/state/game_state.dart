import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzial/multiple_firebase_options.dart';
import 'package:puzzial/widgets/puzzle_piece_widget.dart';
import 'package:puzzial/utils/puzzle_generator.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tuple/tuple.dart';
import 'package:puzzial/models/player.dart';
import 'dart:ui' as ui;

abstract class GameStateFactory {
  Future<GameState> create();
}

class DefaultGameStateFactory implements GameStateFactory {
  @override
  Future<GameState> create() async {
    FirebaseApp app = await Firebase.initializeApp(
      name: 'gameStateApp',
      options: MultipleFirebaseOptions.gameStateAppOptions,
    );
    DatabaseReference database = FirebaseDatabase.instanceFor(app: app).ref();
    FirebaseStorage storage = FirebaseStorage.instanceFor(app: app);

    return GameState.internal(database: database, storage: storage, app: app);
  }
}

/// [GameState] manages the game state of the puzzial app.
class GameState extends ChangeNotifier {
  static late GameStateFactory factory;

  /// Firebase instances
  DatabaseReference? database;
  FirebaseStorage? storage;
  FirebaseApp? app;

  /// Session and authentication
  bool loggedIn = false;
  bool isSinglePlayer = true;
  String? sessionId;
  Set<String> sessionUserIds = {};

  /// Puzzle properties
  late int pieceHeight = 0;
  late int pieceWidth = 0;
  late int rows = 2;
  late int cols = 2;
  late int components;
  late double puzzleLeft;
  late double puzzleTop;
  late double puzzleHeight;
  late double puzzleWidth;
  late double puzzleLeftBound;
  late double puzzleTopBound;
  late double puzzleRightBound;
  late double puzzleBottomBound;
  late String downloadUrl = "";

  /// Screen dimensions
  late double screenWidth;
  late double screenHeight;

  /// Game state
  int currentLevel = 0;
  bool isGameOver = false;

  /// Puzzle elements
  XFile? puzzleImage;
  late Uint8List hintImageBytes;
  List<PuzzlePiece> pieces = [];
  List<Tuple2> gridPositions = [];

  /// Players
  List<Player> players = [];

  /// Random number generator
  final Random random = Random();

  GameState._();

  /// The singleton instance of the game state object.
  static final GameState _instance = GameState._();

  /// Returns the singleton instance of the game state object.
  static GameState get instance => _instance;

  /// Factory constructor that returns a new instance of the game state object
  /// with the specified [database], [storage], and [app] references.
  factory GameState.internal({
    required DatabaseReference database,
    required FirebaseStorage storage,
    required FirebaseApp app,
  }) {
    return _instance
      ..app = app
      ..database = database
      ..storage = storage;
  }

  /// Generates a random double within the specified range.
  double randomInRange(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  /// Sets the game over status and notifies listeners.
  void setGameOver(bool isOver) {
    isGameOver = isOver;
  }

  /// Resets the puzzle by updating piece positions and game state.
  Future<void> resetPuzzle() async {
    if (!isGameOver) {
      setPuzzleBounds();
      randomizePiecePositions();
      components = pieces.length;
      await updateDatabase();
      notifyListeners();
    }
  }

  /// Sets the puzzle bounds based on the screen dimensions.
  void setPuzzleBounds() {
    puzzleLeftBound = screenWidth * 0.1;
    puzzleTopBound = screenHeight * 0.1;
    puzzleRightBound = screenWidth * 0.6;
    puzzleBottomBound = screenHeight * 0.6;
  }

  /// Randomizes the positions of puzzle pieces.
  void randomizePiecePositions() {
    for (int i = 0; i < pieces.length; i++) {
      double left = randomInRange(puzzleLeftBound, puzzleRightBound);
      double top = randomInRange(puzzleTopBound, puzzleBottomBound);
      Offset newPosition = Offset(left, top);
      pieces[i].position = newPosition;
      pieces[i].previousPosition = newPosition;
      pieces[i].isAssembled = false;
      pieces[i].isOccupied = false;
    }
  }

  /// Updates the game state in the database.
  Future<void> updateDatabase() async {
    await GameState.instance.database?.child('$sessionId/').update(
      {
        'components': pieces.length,
        'pieces': List.generate(
          pieces.length,
          (index) => {
            'isAssembled': pieces[index].isAssembled,
            'isOccupied': pieces[index].isOccupied,
            'position': {
              'left': pieces[index].position.dx,
              'top': pieces[index].position.dy
            },
          },
        ),
      },
    );
  }

  /// Converts the game state to a JSON-compatible map.
  Future<Map<String, dynamic>> toJson() async {
    return {
      'rows': rows,
      'cols': cols,
      'components': components,
      'pieces': _generatePieceInfo(),
      'gridPos': _generateGridPositionInfo(),
      'isGameOver': isGameOver,
      'numOfPlayer': players.length,
    };
  }

  /// Generates a list of maps containing information about each piece.
  List<Map<String, dynamic>> _generatePieceInfo() {
    return List.generate(
      pieces.length,
      (index) => {
        'isAssembled': pieces[index].isAssembled,
        'isOccupied': pieces[index].isOccupied,
        'position': {
          'left': pieces[index].position.dx,
          'top': pieces[index].position.dy
        },
      },
    );
  }

  /// Generates a list of maps containing information about each grid position.
  List<Map<String, dynamic>> _generateGridPositionInfo() {
    return List.generate(
      gridPositions.length,
      (index) =>
          {'x': gridPositions[index].item1, 'y': gridPositions[index].item2},
    );
  }

  /// Saves the current game state to the database.
  Future<void> saveState(String session) async {
    Map<String, dynamic> state = await toJson();
    await database!.update({session: state});
  }

  /// Converts an XFile to a ui.Image.
  Future<ui.Image> xFileToUiImage(XFile file) async {
    Uint8List bytes = await file.readAsBytes();
    hintImageBytes = bytes;
    return bytesToUiImage(bytes);
  }

  /// Converts a Uint8List of bytes to a ui.Image.
  Future<ui.Image> uintBytesToImage(Uint8List bytes) async {
    return bytesToUiImage(bytes);
  }

  /// Converts a byte array to a ui.Image.
  Future<ui.Image> bytesToUiImage(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  /// Saves the image to Firebase storage and updates the download URL.
  Future<void> saveImageToStorage() async {
    try {
      String filePath = 'images/$sessionId.png';
      File file = File(puzzleImage!.path);
      Reference ref = storage!.ref().child(filePath);
      TaskSnapshot snapshot = await ref.putFile(file);
      downloadUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      return;
    }
  }

  /// Downloads an image from Firebase storage using the provided download URL.
  Future<Uint8List> downloadImageFromStorage(String downloadUrl) async {
    Reference ref = storage!.refFromURL(downloadUrl);
    Uint8List bytes = await ref.getData() as Uint8List;
    return bytes;
  }

  /// Generates a list of PuzzlePiece objects, either from provided pieces information or using random positions.
  Future<List<PuzzlePiece>> generatePuzzle({
    List<Map<String, dynamic>>? piecesInfo,
    Uint8List? imageBytes,
  }) async {
    // Obtain the image either from imageBytes or from puzzleImage
    ui.Image image = imageBytes != null
        ? await uintBytesToImage(imageBytes)
        : await xFileToUiImage(puzzleImage!);

    List<ui.Image> puzzleImages = await splitImage(image, rows, cols);
    List<PuzzlePiece> pieces = [];
    _definePuzzleBounds();

    for (int i = 0; i < puzzleImages.length; i++) {
      final ByteData? byteData =
          await puzzleImages[i].toByteData(format: ui.ImageByteFormat.png);
      if (_isValidPiecesInfo(piecesInfo, puzzleImages.length)) {
        pieces.add(_createPuzzlePieceFromInfo(piecesInfo!, i, byteData));
      } else {
        pieces.add(_createRandomPuzzlePiece(piecesInfo, i, byteData));
      }
    }
    return pieces;
  }

  /// Defines the puzzle boundaries based on screen dimensions.
  void _definePuzzleBounds() {
    puzzleLeftBound = screenWidth * 0.1;
    puzzleTopBound = screenHeight * 0.1;
    puzzleRightBound = screenWidth * 0.6;
    puzzleBottomBound = screenHeight * 0.6;
  }

  /// Checks if the provided piecesInfo list is valid and matches the expected length.
  bool _isValidPiecesInfo(List<Map<String, dynamic>>? piecesInfo, int length) {
    return piecesInfo != null && piecesInfo.length == length;
  }

  /// Creates a PuzzlePiece object from the provided piecesInfo at the given index.
  PuzzlePiece _createPuzzlePieceFromInfo(
      List<Map<String, dynamic>> piecesInfo, int index, ByteData? byteData) {
    double left = piecesInfo[index]['position']['left'] as double;
    double top = piecesInfo[index]['position']['top'] as double;

    return PuzzlePiece(
      isAssembled: piecesInfo[index]['isAssembled'],
      isOccupied: piecesInfo[index]['isOccupied'],
      pieceId: index,
      subImage: Image.memory(
        byteData!.buffer.asUint8List(),
      ),
      position: Offset(left, top),
      previousPosition: Offset(left, top),
    );
  }

  /// Creates a random PuzzlePiece object, optionally using the provided piecesInfo as a source for some properties.
  PuzzlePiece _createRandomPuzzlePiece(
      List<Map<String, dynamic>>? piecesInfo, int index, ByteData? byteData) {
    double left = randomInRange(puzzleLeftBound, puzzleRightBound);
    double top = randomInRange(puzzleTopBound, puzzleBottomBound);

    return PuzzlePiece(
      isAssembled:
          piecesInfo != null ? piecesInfo[index]['isAssembled'] : false,
      isOccupied: piecesInfo != null ? piecesInfo[index]['isOccupied'] : false,
      pieceId: index,
      subImage: Image.memory(
        byteData!.buffer.asUint8List(),
      ),
      position: Offset(left, top),
      previousPosition: Offset(left, top),
    );
  }

  /// Validates a session by checking if it exists and has less than 2 players.
  Future<bool> validateSession(String sessionId) async {
    if (sessionId.isEmpty) {
      return false;
    }

    final DataSnapshot snapshot = await database!.child(sessionId).get();

    // Check if the session exists and has numOfPlayer property.
    if (snapshot.exists &&
        _hasValidNumberOfPlayers((snapshot.value as Map<Object?, Object?>)
            .cast<String, dynamic>())) {
      return true;
    }
    return false;
  }

  /// Determines if the session has a valid number of players (less than 2).
  bool _hasValidNumberOfPlayers(Map<String, dynamic> sessionData) {
    return sessionData.containsKey('numOfPlayer') &&
        sessionData['numOfPlayer'] < 2;
  }

  /// Reloads a session by updating the GameState instance with the session data.
  Future<void> reloadSession(String sessionId, String imageLink) async {
    if (sessionId.isNotEmpty) {
      final DataSnapshot sessionSnapshot =
          await database!.child(sessionId).get();

      if (sessionSnapshot.exists) {
        // Load the session data into the GameState instance
        GameState state = GameState.instance;
        Map<String, dynamic> sessionData =
            (sessionSnapshot.value as Map<Object?, Object?>)
                .cast<String, dynamic>();

        // Update the GameState properties based on the session data
        _updateGameStateFromSessionData(state, sessionData);

        List<Map<String, dynamic>> piecesInfo = (sessionData['pieces'] as List)
            .map((e) => (e as Map<Object?, Object?>).cast<String, dynamic>())
            .toList();

        Uint8List imageBytes = await downloadImageFromStorage(imageLink);
        state.pieces = await generatePuzzle(
            piecesInfo: piecesInfo, imageBytes: imageBytes);
        state.hintImageBytes = imageBytes;

        state.downloadUrl = imageLink;
        state.notifyListeners();
      } else {
        return;
      }
    } else {
      return;
    }
  }

  /// Updates the GameState instance properties based on the session data.
  void _updateGameStateFromSessionData(
      GameState state, Map<String, dynamic> sessionData) {
    state.rows = sessionData['rows'];
    state.cols = sessionData['cols'];
    state.components = sessionData['components'];
    state.isGameOver = sessionData['isGameOver'];
    state.gridPositions = (sessionData['gridPos'] as List)
        .map((data) => Tuple2(data['x'], data['y']))
        .toList();
  }

  /// Notifies the game state about changes in the game.
  ///
  /// This method is used to update the game state with any changes
  /// related to game pieces or the game status itself.
  ///
  /// [pieceId] (optional): The ID of the game piece that has changed.
  /// [left] (optional): The new left position of the game piece.
  /// [top] (optional): The new top position of the game piece.
  /// [components] (optional): The new number of components in the game.
  /// [numOfPlayer] (optional): The new number of players in the game.
  /// [isAssembled] (optional): A boolean indicating if the game piece is assembled.
  /// [isOccupied] (optional): A boolean indicating if the game piece is occupied.
  /// [isGameOver] (optional): A boolean indicating if the game is over.
  ///
  /// Returns a [Future] that completes when the game state has been updated.
  ///
  /// Example:
  ///
  /// ```
  /// await notifyGameChange(
  ///   pieceId: 1,
  ///   left: 50.0,
  ///   top: 100.0,
  ///   isAssembled: true,
  ///   isOccupied: false,
  /// );
  /// ```
  Future<void> notifyGameChange({
    int? pieceId,
    double? left,
    double? top,
    int? components,
    int? numOfPlayer,
    bool? isAssembled,
    bool? isOccupied,
    bool? isGameOver,
  }) async {
    GameState state = GameState.instance;
    if (pieceId != null) {
      if (left != null && top != null) {
        state.pieces[pieceId].position = Offset(left, top);
      }
      if (isAssembled != null) {
        state.pieces[pieceId].isAssembled = isAssembled;
      }
      if (isOccupied != null) {
        state.pieces[pieceId].isOccupied = isOccupied;
      }
    } else {
      if (isGameOver != null) {
        state.isGameOver = isGameOver;
      }
      if (components != null) {
        state.components = components;
      }
    }
    state.notifyListeners();
  }
}
