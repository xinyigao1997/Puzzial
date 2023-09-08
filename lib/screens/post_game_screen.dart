import 'package:flutter/material.dart';
import 'package:puzzial/screens/home_screen.dart';

/// A [StatefulWidget] that displays a congratulatory message when the game is completed,
/// and a button to return to the main menu.
class GameEndPage extends StatefulWidget {
  final VoidCallback onMainMenuPressed;
  const GameEndPage({super.key, required this.onMainMenuPressed});

  @override
  State<GameEndPage> createState() => _GameEndPageState();
}

/// The [_GameEndPageState] class represents the state object for the
/// [GameEndPage] widget. It defines the UI layout and behavior of the
/// game end page.
class _GameEndPageState extends State<GameEndPage> {
  /// Builds the game end page UI.
  ///
  /// This method constructs a [WillPopScope] to prevent the user from
  /// going back, and it displays a congratulatory message. The UI also
  /// contains a button that, when pressed, calls the provided
  /// `onMainMenuPressed` callback and navigates the user back to the home screen.
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: "congratulations, you have completed this game",
                        child: const Material(
                          color: Colors.transparent,
                          child: Text(
                            'Congrats!',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, left: 20.0),
                  child: Semantics(
                    label: "click to exit this game and return to main menu.",
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton.icon(
                        label: const Text(
                          'Home Page',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                        onPressed: () {
                          widget.onMainMenuPressed();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
