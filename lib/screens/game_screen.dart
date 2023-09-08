import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/avatar_column_widget.dart';
import 'package:puzzial/widgets/button_widget.dart';
import 'package:puzzial/widgets/pieces_left_indicator_widget.dart';
import 'package:puzzial/widgets/puzzle_board_widget.dart';
import 'package:puzzial/widgets/share_button_widget.dart';
import 'package:puzzial/widgets/hint_popup_widget.dart';

/// This is the game page of the Puzzial app, where the puzzle game is displayed and played.
///
/// This page displays the puzzle game with a puzzle board, puzzle pieces, buttons for various actions
/// such as going back, refreshing the puzzle, saving the puzzle state, and showing hints, and other
/// UI elements such as avatar column, pieces left indicator, and share button.
///
/// The puzzle board is a draggable grid where the puzzle pieces can be moved and placed to solve
/// the puzzle. The game state is managed using a [ValueNotifier] and [Provider] pattern.
///
/// The game page also uses a [ValueListenable] to listen to changes in the [isCutting] property,
/// which indicates whether the puzzle pieces are being cut, to show a loading spinner during the
/// cutting process.
class GamgePage extends StatefulWidget {
  final ValueListenable<bool> isCutting;
  final ValueListenable<GameState> gameState =
      ValueNotifier(GameState.instance);
  GamgePage({super.key, required this.isCutting});

  final List<String> buttonImagePaths = [
    'assets/images/back.png',
    'assets/images/refresh.png',
    'assets/images/save.png',
    'assets/images/idea.png',
  ];

  @override
  State<GamgePage> createState() => _GamgePageState();
}

/// The stateful widget for the game page.
class _GamgePageState extends State<GamgePage> {
  double borderSize = 4;
  final ValueNotifier<bool> _hintPopupVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final GameState state = GameState.instance;
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<GameState>(builder: (context, gameState, child) {
        return Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: widget.isCutting,
            builder: (context, isCutting, child) {
              if (isCutting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double boardWidth = gameState.screenWidth * 0.82;
                    double boardHeight = gameState.screenHeight * 0.8;
                    double boardTop = gameState.screenHeight * 0.05;
                    double boardLeft = gameState.screenWidth * 0.05;
                    state.puzzleTop = boardTop * 1.05;
                    state.puzzleLeft = boardLeft * 1.05;
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/background.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        PuzzleBoard(
                          boardTop: boardTop,
                          boardLeft: boardLeft,
                          boardWidth: boardWidth,
                          boardHeight: boardHeight,
                          borderSize: borderSize,
                        ),
                        ...List.generate(state.pieces.length,
                            (index) => state.pieces[index]),
                        const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: AvatarColumn(),
                          ),
                        ),
                        state.isSinglePlayer
                            ? Container()
                            : const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 20.0, bottom: 150.0),
                                  child: ShareButton(),
                                ),
                              ),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0, bottom: 80.0),
                            child: PiecesLeftIndicator(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                  widget.buttonImagePaths.length, (index) {
                                return Container(
                                  color: Colors.transparent,
                                  width: 30,
                                  height: 30,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomButton(
                                        onTap: () {
                                          switch (index) {
                                            case 0:
                                              Navigator.pop(context);
                                              break;
                                            case 1:
                                              state.resetPuzzle();
                                              break;
                                            case 2:
                                              state.saveState(state.sessionId!);
                                              break;
                                            case 3:
                                              _hintPopupVisible.value =
                                                  !_hintPopupVisible.value;
                                              break;
                                          }
                                        },
                                        imageUrl:
                                            widget.buttonImagePaths[index],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        HintPopUp(
                          imageBytes: state.hintImageBytes,
                          visible: _hintPopupVisible,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        );
      }),
    );
  }
}
