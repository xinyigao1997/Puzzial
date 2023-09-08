import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/screens/post_game_screen.dart';
import 'package:puzzial/state/game_state.dart';

/// A widget representing a puzzle piece.
///
/// This widget creates a draggable puzzle piece with a sub-image and position.
/// The puzzle piece can be assembled by dragging it to the correct location.
// ignore: must_be_immutable
class PuzzlePiece extends StatefulWidget {
  final int pieceId;
  final Image subImage;
  bool isAssembled;
  bool isOccupied;
  Offset position;
  Offset previousPosition;

  PuzzlePiece({
    Key? key,
    required this.pieceId,
    required this.subImage,
    required this.position,
    required this.previousPosition,
    this.isAssembled = false,
    this.isOccupied = false,
  }) : super(key: key);

  @override
  PuzzlePieceState createState() => PuzzlePieceState();
}

/// The state object for [PuzzlePiece].
class PuzzlePieceState extends State<PuzzlePiece>
    with TickerProviderStateMixin {
  Offset touchOffset = Offset.zero;

  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;
  late StreamSubscription<DatabaseEvent> _pieceSubscription;
  late StreamSubscription<DatabaseEvent> _gameStateSubscription;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_opacityController);
    final GameState state = GameState.instance;
    state.addListener(_onGameStateChange);
    _setupFirebaseListeners();
    _opacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed && state.isGameOver) {
        _navigateToCongratsPage();
      }
    });
  }

  /// Resets the game over state in the [GameState] instance.
  ///
  /// This method sets the game over state in the [GameState] instance to false,
  /// indicating that the game is no longer in a game over state.
  void _resetGameOver() {
    GameState.instance.setGameOver(false);
  }

  /// Navigates to the congratulations page.
  ///
  /// This method pushes a new [GameEndPage] onto the navigation stack. When the
  /// "Main Menu" button is pressed on the congratulations page, the [_resetGameOver]
  /// method is called to reset the game over state.
  void _navigateToCongratsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameEndPage(
          onMainMenuPressed: _resetGameOver,
        ),
      ),
    );
  }

  /// Sets up Firebase listeners for puzzle piece and game state updates.
  ///
  /// This method establishes listeners for changes in the position,
  /// assembled status, and occupied status of the puzzle piece, as well
  /// as changes in the game state's components and gameOver properties.
  void _setupFirebaseListeners() {
    _pieceSubscription = GameState.instance.database!
        .child('${GameState.instance.sessionId}/pieces/${widget.pieceId}')
        .onChildChanged
        .listen((event) {
      final GameState state = GameState.instance;
      if (event.snapshot.key == 'position') {
        final pos = (event.snapshot.value as Map<Object?, Object?>)
            .cast<String, double>();
        state.notifyGameChange(
            pieceId: widget.pieceId, left: pos['left'], top: pos['top']);
      } else if (event.snapshot.key == 'top') {
        state.notifyGameChange(
            pieceId: widget.pieceId, top: event.snapshot.value as double);
      } else if (event.snapshot.key == 'isAssembled') {
        state.notifyGameChange(
            pieceId: widget.pieceId, isAssembled: event.snapshot.value as bool);
      } else if (event.snapshot.key == 'isOccupied') {
        state.notifyGameChange(
            pieceId: widget.pieceId, isOccupied: event.snapshot.value as bool);
      }
    });
    _gameStateSubscription = GameState.instance.database!
        .child(GameState.instance.sessionId!)
        .onChildChanged
        .listen((event) {
      final GameState state = GameState.instance;
      if (event.snapshot.key == 'components') {
        state.notifyGameChange(components: event.snapshot.value as int);
      } else if (event.snapshot.key == 'isGameOver') {
        state.notifyGameChange(isGameOver: event.snapshot.value as bool);
      }
    });
  }

  /// Cleans up resources and removes listeners before the widget is disposed.
  ///
  /// This method is called when this widget is removed from the tree permanently.
  /// It disposes of the [_opacityController], removes the [_onGameStateChange]
  /// listener from the [GameState] instance, and cancels the [_pieceSubscription]
  /// and [_gameStateSubscription].
  @override
  void dispose() {
    final GameState state = GameState.instance;
    _opacityController.dispose();
    state.removeListener(_onGameStateChange);
    _pieceSubscription.cancel();
    _gameStateSubscription.cancel();
    super.dispose();
  }

  /// Handles game state changes by animating the opacity of assembled puzzle pieces.
  ///
  /// This method updates the opacity of assembled puzzle pieces when the game state
  /// changes. If all components are assembled or the game is over, the opacity
  /// animation is triggered.
  void _onGameStateChange() {
    final GameState state = GameState.instance;
    if (state.components == 0 || state.isGameOver == true) {
      _opacityController.forward();
    }
  }

  /// Builds the widget tree for the puzzle piece.
  ///
  /// This method returns a [Stack] widget that includes a [Positioned] puzzle piece.

  @override
  Widget build(BuildContext context) {
    final GameState state = GameState.instance;
    double boardWidth = state.screenWidth * 0.8;
    double boardHeight = state.screenHeight * 0.8;
    double boardTop = state.screenHeight * 0.05;
    double boardLeft = state.screenWidth * 0.05;

    return Consumer<GameState>(builder: (context, gameState, child) {
      return Stack(
        children: [
          Positioned(
            left: widget.position.dx,
            top: widget.position.dy,
            child: GestureDetector(
              onPanDown: (details) {
                if (!widget.isAssembled) {
                  touchOffset = details.localPosition;
                  widget.previousPosition = widget.position;
                  state.database!
                      .child('${state.sessionId!}/pieces/${widget.pieceId}')
                      .update({'isOccupied': true});
                }
              },
              onPanUpdate: (details) {
                if (!widget.isAssembled) {
                  setState(() {
                    widget.position = details.globalPosition - touchOffset;
                  });
                  state.database!
                      .child('${state.sessionId!}/pieces/${widget.pieceId}')
                      .update({
                    'position': {
                      'left': widget.position.dx,
                      'top': widget.position.dy,
                    }
                  });
                }
              },
              onPanEnd: (details) {
                if (!widget.isAssembled) {
                  state.database!
                      .child('${state.sessionId!}/pieces/${widget.pieceId}')
                      .update({
                    'isOccupied': false,
                  });
                  if (widget.position.dx < boardLeft ||
                      widget.position.dx > boardLeft + boardWidth ||
                      widget.position.dy < boardTop ||
                      widget.position.dy > boardTop + boardHeight) {
                    setState(() {
                      widget.position = widget.previousPosition;
                    });
                    state.database!
                        .child('${state.sessionId!}/pieces/${widget.pieceId}')
                        .update({
                      'position': {
                        'left': widget.position.dx,
                        'top': widget.position.dy,
                      },
                    });
                  }
                  if ((widget.position.dx -
                                  boardLeft -
                                  state.gridPositions[widget.pieceId].item1)
                              .abs() <=
                          5 &&
                      (widget.position.dy -
                                  boardTop -
                                  state.gridPositions[widget.pieceId].item2)
                              .abs() <=
                          5) {
                    setState(() {
                      widget.position = Offset(
                          state.gridPositions[widget.pieceId].item1.toDouble() +
                              boardLeft,
                          state.gridPositions[widget.pieceId].item2.toDouble() +
                              boardTop);
                      state.database!
                          .child('${state.sessionId!}/pieces/${widget.pieceId}')
                          .update({
                        'position': {
                          'left': widget.position.dx,
                          'top': widget.position.dy,
                        }
                      });
                      widget.isAssembled = true;
                      state.database!
                          .child('${state.sessionId!}/pieces/${widget.pieceId}')
                          .update({'isAssembled': true});
                    });
                    state.components--;
                    state.database!
                        .child('${state.sessionId!}/')
                        .update({'components': state.components});
                    if (state.components == 0) {
                      state.setGameOver(true);
                      state.database!
                          .child('${state.sessionId}/')
                          .update({'isGameOver': state.isGameOver});
                    }
                  }
                }
              },
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) => Opacity(
                  opacity: widget.isAssembled ? _opacityAnimation.value : 1.0,
                  child: child,
                ),
                child: SizedBox(
                  width: state.pieceWidth.toDouble(),
                  height: state.pieceHeight.toDouble(),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: widget.subImage,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
