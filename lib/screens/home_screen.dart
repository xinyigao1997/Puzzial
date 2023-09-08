import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:puzzial/screens/picker_screen.dart';
import 'package:puzzial/widgets/game_mode_controller_widget.dart';

const String clientId =
    '198146297205-b5ebbbo4i6n7idab41184n383mvl7nkv.apps.googleusercontent.com';

/// A screen that serves as the home screen of the Puzzial game.
///
/// The screen contains a background image, user profile icon button, settings icon button,
/// start game button, and sign out button.
///
/// The [HomeScreen] is built using [Scaffold] widget as the root element,
/// and a [Container] widget as the body which contains a [Column] widget that holds
/// all the other widgets.
///
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// The background image for the [HomeScreen].
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            /// The user profile icon button, that when pressed, navigates to the user profile screen.
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 30),
              child: Align(
                alignment: Alignment.topRight,
                child: Semantics(
                  label: "Click to access user profile",
                  child: IconButton(
                    icon: const Icon(Icons.person_sharp),
                    color: Colors.white.withOpacity(0.9),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<ProfileScreen>(
                          builder: (context) => ProfileScreen(
                            appBar: AppBar(
                              title: const Text('User Profile'),
                            ),
                            actions: [
                              SignedOutAction((context) {
                                Navigator.of(context).pop();
                              })
                            ],
                            providerConfigs: const [
                              GoogleProviderConfiguration(
                                clientId: clientId,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            /// The settings icon button, that when pressed, navigates to the game mode controller widget screen.
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 30),
              child: Align(
                alignment: Alignment.topRight,
                child: Semantics(
                  label:
                      "click to change game settings and toggle between single player mode and multiplayer mode",
                  child: IconButton(
                    icon: const Icon(Icons.settings_sharp),
                    color: Colors.white.withOpacity(0.9),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const GameModeControllerWidget(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            /// The start game button, that when pressed, navigates to the picture selector screen.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Semantics(
                label: "click this button to start game",
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PictureSelectorPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.black.withOpacity(0.8), // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    minimumSize: const Size(150, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: Colors.deepPurple.shade700, width: 2),
                    ),
                    elevation: 5, // Shadow elevation
                    shadowColor: Colors.deepPurple.shade300, // Shadow color
                  ),
                  child: const Text(
                    'START GAME',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            /// The sign out button.
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 30),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Semantics(
                      label: "click to sign out and quit game",
                      child: const SignOutButton())),
            )
          ],
        ),
      ),
    );
  }
}
