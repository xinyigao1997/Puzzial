import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:puzzial/state/game_state.dart';

/// A widget that displays the number of pieces left to be assembled.
///
/// This widget creates an indicator to show how many puzzle pieces are
/// remaining to be assembled on the puzzle board.
class PiecesLeftIndicator extends StatefulWidget {
  const PiecesLeftIndicator({
    Key? key,
  }) : super(key: key);

  @override
  PiecesLeftIndicatorState createState() => PiecesLeftIndicatorState();
}

class PiecesLeftIndicatorState extends State<PiecesLeftIndicator> {
  late int piecesLeft;
  late StreamSubscription<DatabaseEvent> _componentsSubscription;

  /// Initializes the state by setting up the initial number of pieces left
  /// and listening to the database for changes in the number of components.
  @override
  void initState() {
    super.initState();
    piecesLeft = GameState.instance.components;
    _componentsSubscription = GameState.instance.database!
        .child('${GameState.instance.sessionId}/components')
        .onValue
        .listen((event) {
      setState(() {
        piecesLeft = event.snapshot.value as int;
      });
    });
  }

  /// Disposes the state by canceling the database subscription.
  @override
  void dispose() {
    _componentsSubscription.cancel();
    super.dispose();
  }

  /// Builds the PiecesLeftIndicator widget.
  ///
  /// This method returns a [Container] widget containing a [Text] widget
  /// that displays the number of pieces left to be assembled.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        'Left: $piecesLeft',
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
