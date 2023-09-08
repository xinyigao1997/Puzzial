import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/grid_widget.dart';

/// A widget that displays the puzzle board with its grid cells.
///
/// This widget creates the puzzle board where pieces are assembled.
/// It also shows the grid cells if the game is not over.
class PuzzleBoard extends StatefulWidget {
  final double boardTop;
  final double boardLeft;
  final double boardWidth;
  final double boardHeight;
  final double borderSize;

  /// Creates a new PuzzleBoard with the given dimensions and border size.
  
  const PuzzleBoard({
    Key? key,
    required this.boardTop,
    required this.boardLeft,
    required this.boardWidth,
    required this.boardHeight,
    required this.borderSize,
  }) : super(key: key);

  @override
  PuzzleBoardState createState() => PuzzleBoardState();
}

class PuzzleBoardState extends State<PuzzleBoard> {
  /// Builds the puzzle board and grid cells if the game is not over.
  ///
  /// This method returns a [Positioned] widget containing the puzzle board
  /// and its grid cells if the game is not over.
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, gameState, child) {
      return Positioned(
        top: widget.boardTop,
        left: widget.boardLeft,
        child: Stack(
          children: [
            Container(
              width: widget.boardWidth + widget.borderSize * 3,
              height: widget.boardHeight + widget.borderSize * 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(widget.borderSize * 3),
                child: Container(
                  width: widget.boardWidth - widget.borderSize * 3,
                  height: widget.boardHeight - widget.borderSize * 3,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/images/background3.jpg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (!gameState.isGameOver)
              ...List.generate(
                GameState.instance.gridPositions.length,
                (index) => BorderedGrid(
                  gridLeft:
                      GameState.instance.gridPositions[index].item1.toDouble(),
                  gridTop:
                      GameState.instance.gridPositions[index].item2.toDouble(),
                  gridHeight: GameState.instance.pieceHeight,
                  gridWidth: GameState.instance.pieceWidth,
                  borderOpacity: 0.3,
                ),
              ),
          ],
        ),
      );
    });
  }
}
