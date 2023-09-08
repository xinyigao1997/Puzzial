import 'package:flutter/material.dart';
import 'package:puzzial/state/game_state.dart';

/// A StatelessWidget that represents a bordered grid.
///
/// This widget creates a grid with a customizable position, height, width,
/// and border opacity. It is used in the puzzle game to display grid elements.
class BorderedGrid extends StatelessWidget {
  /// The distance from the left edge of the parent widget to the grid.
  final double gridLeft;

  /// The distance from the top edge of the parent widget to the grid.
  final double gridTop;

  /// The height of the grid, expressed as an integer.
  final int gridHeight;

  /// The width of the grid, expressed as an integer.
  final int gridWidth;

  /// The opacity of the border around the grid.
  final double borderOpacity;

  /// Constructs a BorderedGrid widget.
  ///
  /// Requires [gridLeft], [gridTop], [gridHeight], [gridWidth], and [borderOpacity] parameters.
  const BorderedGrid({
    Key? key,
    required this.gridLeft,
    required this.gridTop,
    required this.gridHeight,
    required this.gridWidth,
    required this.borderOpacity,
  }) : super(key: key);

  @override
  Widget build(context) {
    return Positioned(
      left: gridLeft,
      top: gridTop,
      child: Container(
        height: GameState.instance.pieceHeight.toDouble(),
        width: GameState.instance.pieceWidth.toDouble(),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(
            color: Colors.brown.withOpacity(borderOpacity),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
